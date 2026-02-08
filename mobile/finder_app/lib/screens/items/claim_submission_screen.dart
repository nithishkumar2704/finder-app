import 'package:flutter/material.dart';
import '../../models/item.dart';
import '../../services/claim_service.dart';

class ClaimSubmissionScreen extends StatefulWidget {
  final Item item;

  const ClaimSubmissionScreen({super.key, required this.item});

  @override
  State<ClaimSubmissionScreen> createState() => _ClaimSubmissionScreenState();
}

class _ClaimSubmissionScreenState extends State<ClaimSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _claimService = ClaimService();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  void _submitClaim() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await _claimService.submitClaim(
        widget.item.id,
        _descriptionController.text,
        [], // Images would be added here
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Claim submitted successfully! Admin will verify soon.')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit claim.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Claim Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Proving ownership of:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  title: Text(widget.item.title),
                  subtitle: Text(widget.item.categoryName),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Describe the item in detail (e.g., specific marks, contents, or serial numbers) to prove it is yours.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter ownership details...',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please provide details' : null,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  // Proof image picker logic
                },
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Add Proof Images (ID, Receipt, etc.)'),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitClaim,
                      child: const Text('Submit Claim'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
