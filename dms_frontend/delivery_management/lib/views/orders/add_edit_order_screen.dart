import 'package:flutter/material.dart';

class AddEditOrderScreen extends StatefulWidget {
  final Map<String, dynamic>? order;

  const AddEditOrderScreen({super.key, this.order});

  @override
  State<AddEditOrderScreen> createState() => _AddEditOrderScreenState();
}

class _AddEditOrderScreenState extends State<AddEditOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final customerController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final remarksController = TextEditingController();

  DateTime? deliveryDate;
  TimeOfDay? deliveryTime;

  String status = "Pending";

  final List<String> statusList = [
    "Pending",
    "Picked Up",
    "Out for Delivery",
    "Delivered",
    "Cancelled",
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.order != null) {
      customerController.text = widget.order!["customer"] ?? "";

      phoneController.text = widget.order!["phone"] ?? "";

      addressController.text = widget.order!["address"] ?? "";

      remarksController.text = widget.order!["remarks"] ?? "";

      status = widget.order!["status"] ?? "Pending";
    }
  }

  @override
  void dispose() {
    customerController.dispose();
    phoneController.dispose();
    addressController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        deliveryDate = picked;
      });
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        deliveryTime = picked;
      });
    }
  }

  Future<void> saveOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (deliveryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select delivery date")),
      );
      return;
    }

    if (deliveryTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select delivery time")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.order == null
              ? "Order Created Successfully"
              : "Order Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.order != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Order" : "Add Order")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: customerController,
                decoration: inputDecoration("Customer Name", Icons.person),
                validator: (value) =>
                    value!.isEmpty ? "Enter customer name" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: inputDecoration("Phone Number", Icons.phone),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter phone number";
                  }

                  if (value.length != 10) {
                    return "Enter valid phone number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: inputDecoration(
                  "Delivery Address",
                  Icons.location_on,
                ),
                validator: (value) => value!.isEmpty ? "Enter address" : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: status,
                decoration: inputDecoration("Status", Icons.delivery_dining),
                items: statusList
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  deliveryDate == null
                      ? "Select Delivery Date"
                      : "${deliveryDate!.day}/${deliveryDate!.month}/${deliveryDate!.year}",
                ),
                trailing: const Icon(Icons.edit),
                onTap: pickDate,
              ),

              ListTile(
                leading: const Icon(Icons.timer),
                title: Text(
                  deliveryTime == null
                      ? "Select Delivery Time"
                      : deliveryTime!.format(context),
                ),
                trailing: const Icon(Icons.edit),
                onTap: pickTime,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: remarksController,
                maxLines: 4,
                decoration: inputDecoration("Remarks", Icons.note_alt),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : saveOrder,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(isEdit ? "UPDATE ORDER" : "SAVE ORDER"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
