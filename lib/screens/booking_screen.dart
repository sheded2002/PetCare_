import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';

// Screen for managing pet care appointments
class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Database helper instance
  final _databaseHelper = DatabaseHelper();

  // Text controllers for form fields
  final _animalTypeController = TextEditingController();
  final _animalAgeController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected date and time for appointment
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // List of user's bookings
  List<Map<String, dynamic>> _bookings = [];

  // Load user's bookings from database
  Future<void> _loadBookings() async {
    final userId = await _databaseHelper.getCurrentUserId();
    if (userId != null) {
      final bookings = await _databaseHelper.getBookingsByUserId(userId);
      setState(() {
        _bookings = bookings;
      });
    }
  }

  // Submit a new booking
  Future<void> _submitBooking() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Check if user is logged in
    final userId = await _databaseHelper.getCurrentUserId();
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LocaleProvider>().isArabic
                ? 'يرجى تسجيل الدخول أولاً'
                : 'Please login first',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Validate animal age
      final animalAge = int.tryParse(_animalAgeController.text);
      if (animalAge == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<LocaleProvider>().isArabic
                  ? 'يرجى إدخال عمر صحيح للحيوان'
                  : 'Please enter a valid animal age',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create booking DateTime
      final now = DateTime.now();
      final bookingDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Validate booking time (must be at least 6 minutes in the future)
      if (bookingDateTime.isBefore(now.add(const Duration(minutes: 6)))) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<LocaleProvider>().isArabic
                  ? 'يجب أن يكون موعد الحجز بعد 6 دقائق على الأقل من الوقت الحالي'
                  : 'Booking time must be at least 6 minutes from now',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Prepare booking data
      final booking = {
        'user_id': userId,
        'animal_type': _animalTypeController.text,
        'animal_age': animalAge,
        'date': bookingDateTime.toIso8601String(),
        'time': _selectedTime.format(context),
        'notes': _notesController.text,
        'status': 'pending'
      };

      // Insert booking into database
      final bookingId = await _databaseHelper.insertBooking(booking);

      // Schedule notification
      await NotificationService().scheduleBookingNotification(
        id: bookingId,
        title: context.read<LocaleProvider>().isArabic
            ? 'تذكير بالموعد'
            : 'Booking Reminder',
        body: context.read<LocaleProvider>().isArabic
            ? 'لديك موعد بعد 5 دقائق مع ${_animalTypeController.text}'
            : 'You have an appointment with ${_animalTypeController.text} in 5 minutes',
        scheduledDate: bookingDateTime,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<LocaleProvider>().isArabic
                  ? 'تم الحجز بنجاح'
                  : 'Booking submitted successfully',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _loadBookings();
          _resetForm();
        });
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LocaleProvider>().isArabic
                ? 'حدث خطأ أثناء الحجز'
                : 'Error submitting booking',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Select date for appointment
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Select time for appointment
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Reset form fields
  void _resetForm() {
    setState(() {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      _animalTypeController.clear();
      _animalAgeController.clear();
      _notesController.clear();
    });
  }

  // Build bookings list UI
  Widget _buildBookingsList() {
    final isArabic = context.read<LocaleProvider>().isArabic;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        final bookingDate = DateTime.parse(booking['date']);
        final bookingTime = booking['time'];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.grey[100],
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              '${booking['animal_type']} - ${booking['animal_age']} ${isArabic ? 'سنة' : 'years'}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  '${bookingDate.day}/${bookingDate.month}/${bookingDate.year} - $bookingTime',
                  style: const TextStyle(color: Colors.black54),
                ),
                if (booking['notes']?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(
                    booking['notes'],
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => _showEditBookingDialog(booking),
                ),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(booking),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show edit booking dialog
  Future<void> _showEditBookingDialog(Map<String, dynamic> booking) async {
    final isArabic = context.read<LocaleProvider>().isArabic;

    // Set up temporary controllers with current values
    final animalTypeController =
        TextEditingController(text: booking['animal_type']);
    final animalAgeController =
        TextEditingController(text: booking['animal_age'].toString());
    final notesController = TextEditingController(text: booking['notes'] ?? '');

    DateTime selectedDate = DateTime.parse(booking['date']);
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.parse(booking['time'].split(':')[0]),
      minute: int.parse(booking['time'].split(':')[1].split(' ')[0]),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          isArabic ? 'تعديل الحجز' : 'Edit Booking',
          style: const TextStyle(color: Colors.black),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: animalTypeController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: isArabic ? 'نوع الحيوان' : 'Animal Type',
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: animalAgeController,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isArabic ? 'عمر الحيوان' : 'Animal Age',
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                style: const TextStyle(color: Colors.black),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isArabic ? 'ملاحظات' : 'Notes',
                  labelStyle: const TextStyle(color: Colors.black54),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Date picker button
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              // Time picker button
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    selectedTime = picked;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  selectedTime.format(context),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isArabic ? 'إلغاء' : 'Cancel',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final animalAge = int.tryParse(animalAgeController.text);
              if (animalAge == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic
                          ? 'يرجى إدخال عمر صحيح'
                          : 'Please enter a valid age',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final updatedBooking = {
                ...booking,
                'animal_type': animalTypeController.text,
                'animal_age': animalAge,
                'date': selectedDate.toIso8601String(),
                'time': selectedTime.format(context),
                'notes': notesController.text,
              };

              try {
                await _databaseHelper.updateBooking(updatedBooking);

                // Update notification
                await NotificationService().cancelNotification(booking['id']);
                final bookingDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                await NotificationService().scheduleBookingNotification(
                  id: booking['id'],
                  title: isArabic ? 'تذكير بالموعد' : 'Booking Reminder',
                  body: isArabic
                      ? 'لديك موعد بعد 5 دقائق مع ${animalTypeController.text}'
                      : 'You have an appointment with ${animalTypeController.text} in 5 minutes',
                  scheduledDate: bookingDateTime,
                );

                if (mounted) {
                  Navigator.pop(context);
                  _loadBookings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'تم تحديث الحجز بنجاح'
                            : 'Booking updated successfully',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic
                          ? 'حدث خطأ أثناء التحديث'
                          : 'Error updating booking',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              isArabic ? 'حفظ' : 'Save',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(Map<String, dynamic> booking) async {
    final isArabic = context.read<LocaleProvider>().isArabic;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          isArabic ? 'حذف الحجز' : 'Delete Booking',
          style: const TextStyle(color: Colors.black),
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
        ),
        content: Text(
          isArabic
              ? 'هل أنت متأكد من حذف هذا الحجز؟'
              : 'Are you sure you want to delete this booking?',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isArabic ? 'إلغاء' : 'Cancel',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _databaseHelper.deleteBooking(booking['id']);
                await NotificationService().cancelNotification(booking['id']);

                if (mounted) {
                  Navigator.pop(context);
                  _loadBookings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? 'تم حذف الحجز بنجاح'
                            : 'Booking deleted successfully',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic
                          ? 'حدث خطأ أثناء الحذف'
                          : 'Error deleting booking',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              isArabic ? 'حذف' : 'Delete',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animalTypeController.dispose();
    _animalAgeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'حجز موعد' : 'Book Appointment',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6852A5),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'حجز جديد' : 'New Booking',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _animalTypeController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: isArabic ? 'نوع الحيوان' : 'Animal Type',
                          labelStyle: const TextStyle(color: Colors.black54),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic
                                ? 'يرجى إدخال نوع الحيوان'
                                : 'Please enter animal type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _animalAgeController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: isArabic ? 'عمر الحيوان' : 'Animal Age',
                          labelStyle: const TextStyle(color: Colors.black54),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic
                                ? 'يرجى إدخال عمر الحيوان'
                                : 'Please enter animal age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectDate(context),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                padding: const EdgeInsets.all(16),
                              ),
                              child: Text(
                                _selectedDate == DateTime.now()
                                    ? (isArabic ? 'اختر التاريخ' : 'Select Date')
                                    : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectTime(context),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                padding: const EdgeInsets.all(16),
                              ),
                              child: Text(
                                _selectedTime == TimeOfDay.now()
                                    ? (isArabic ? 'اختر الوقت' : 'Select Time')
                                    : _selectedTime.format(context),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: isArabic ? 'ملاحظات' : 'Notes',
                          labelStyle: const TextStyle(color: Colors.black54),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6852A5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          isArabic ? 'تأكيد الحجز' : 'Submit Booking',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (_bookings.isNotEmpty) ...[
                        Text(
                          isArabic ? 'الحجوزات السابقة' : 'Previous Bookings',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildBookingsList(),
                      ] else
                        Text(
                          isArabic
                              ? 'لا توجد حجوزات سابقة'
                              : 'No previous bookings found',
                          style: const TextStyle(color: Colors.black54),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
