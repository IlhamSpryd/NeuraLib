import 'package:flutter/material.dart';
import 'package:athena/views/main/dashboard_page.dart'; // ✅ Tambahkan import ini

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();
    // Set up error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() {
          _errorDetails = details;
        });
      }
    };
  }

  void _resetError() {
    setState(() {
      _errorDetails = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      return _buildErrorScreen(_errorDetails!);
    }
    return widget.child;
  }

  Widget _buildErrorScreen(FlutterErrorDetails details) {
    // Log error
    print("ERROR BOUNDARY CAUGHT: ${details.exception}");
    print("Stack trace: ${details.stack}");

    // Tampilkan fallback UI yang user-friendly
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                "Oops! Something went wrong",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Error: ${details.exception.toString()}",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _resetError,
                child: const Text("Try Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
