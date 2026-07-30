import 'package:delivery_management/views/orders/add_edit_order_screen.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController remarksController = TextEditingController();

  String selectedStatus = "Pending";

  final List<String> statusList = [
    "Pending",
    "Picked Up",
    "Out for Delivery",
    "Delivered",
    "Cancelled",
  ];

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.order["status"];
    remarksController.text = "";
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedOrder = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditOrderScreen(order: widget.order),
                ),
              );

              if (updatedOrder != null) {
                setState(() {
                  widget.order.addAll(updatedOrder);
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: order["id"],
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.local_shipping,
                          size: 35,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        order["customer"],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        order["id"],
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildRow(
                      Icons.location_on,
                      "Delivery Address",
                      order["address"],
                    ),

                    const Divider(),

                    buildRow(Icons.phone, "Phone", "9876543210"),

                    const Divider(),

                    buildRow(Icons.person, "Receiver", order["customer"]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Delivery Status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: statusList
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Delivery Remarks",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: remarksController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Enter delivery remarks...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Delivery Proof",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("No Image Selected"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.camera),
                            label: const Text("Camera"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.photo),
                            label: const Text("Gallery"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Updated Successfully")),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("UPDATE ORDER"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigate to Google Maps screen
                },
                icon: const Icon(Icons.map),
                label: const Text("OPEN MAP"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 5),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
