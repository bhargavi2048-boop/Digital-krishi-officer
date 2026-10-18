import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/crop.dart';
import '../../providers/crop_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddEditCropScreen extends StatefulWidget {
  final Crop? cropToEdit;

  const AddEditCropScreen({super.key, this.cropToEdit});

  @override
  State<AddEditCropScreen> createState() => _AddEditCropScreenState();
}

class _AddEditCropScreenState extends State<AddEditCropScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _varietyController;
  late TextEditingController _landAreaController;
  late TextEditingController _notesController;

  late DateTime _plantingDate;
  late DateTime _expectedHarvestDate;
  late String _selectedSoilType;
  late String _selectedWaterSource;
  late String _selectedStage;

  final List<String> _stages = ['Sown', 'Vegetative', 'Flowering', 'Harvesting', 'Completed'];

  @override
  void initState() {
    super.initState();
    final c = widget.cropToEdit;
    _nameController = TextEditingController(text: c?.name ?? 'Tomato');
    _varietyController = TextEditingController(text: c?.variety ?? 'Hybrid F1');
    _landAreaController = TextEditingController(text: c != null ? c.landAreaAcres.toString() : '1.0');
    _notesController = TextEditingController(text: c?.notes ?? '');

    _plantingDate = c?.plantingDate ?? DateTime.now().subtract(const Duration(days: 30));
    _expectedHarvestDate = c?.expectedHarvestDate ?? DateTime.now().add(const Duration(days: 60));
    _selectedSoilType = c?.soilType ?? 'Alluvial Soil';
    _selectedWaterSource = c?.waterSource ?? 'Drip Irrigation';
    _selectedStage = c?.stage ?? 'Vegetative';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _landAreaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isPlanting) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isPlanting ? _plantingDate : _expectedHarvestDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2E7D32)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPlanting) {
          _plantingDate = picked;
          if (_expectedHarvestDate.isBefore(_plantingDate)) {
            _expectedHarvestDate = _plantingDate.add(const Duration(days: 90));
          }
        } else {
          _expectedHarvestDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  Future<void> _saveCrop() async {
    if (!_formKey.currentState!.validate()) return;

    final cropProv = Provider.of<CropProvider>(context, listen: false);

    if (widget.cropToEdit != null) {
      final updated = widget.cropToEdit!.copyWith(
        name: _nameController.text.trim(),
        variety: _varietyController.text.trim(),
        plantingDate: _plantingDate,
        expectedHarvestDate: _expectedHarvestDate,
        landAreaAcres: double.tryParse(_landAreaController.text.trim()) ?? 1.0,
        soilType: _selectedSoilType,
        waterSource: _selectedWaterSource,
        notes: _notesController.text.trim(),
        stage: _selectedStage,
      );
      await cropProv.updateCrop(updated);
    } else {
      await cropProv.addCrop(
        name: _nameController.text.trim(),
        variety: _varietyController.text.trim(),
        plantingDate: _plantingDate,
        expectedHarvestDate: _expectedHarvestDate,
        landAreaAcres: double.tryParse(_landAreaController.text.trim()) ?? 1.0,
        soilType: _selectedSoilType,
        waterSource: _selectedWaterSource,
        stage: _selectedStage,
        notes: _notesController.text.trim(),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cropToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(isEditing ? context.tr('editCrop') : context.tr('addCrop')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                label: context.tr('cropName'),
                hint: 'e.g. Paddy, Tomato, Wheat, Sugarcane',
                prefixIcon: Icons.grass,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _varietyController,
                label: context.tr('variety'),
                hint: 'e.g. ADT 45, Shivam Hybrid, Shriram 111',
              ),
              const SizedBox(height: 14),

              // Growth Stage Dropdown
              Text(
                context.tr('growthStage'),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedStage,
                    items: _stages.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setState(() => _selectedStage = val ?? _selectedStage),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Planting & Expected Harvest Dates
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('plantingDate'),
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => _pickDate(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 8),
                                Text(_formatDate(_plantingDate), style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('expectedHarvest'),
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => _pickDate(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.event_available, size: 16, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 8),
                                Text(_formatDate(_expectedHarvestDate), style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _landAreaController,
                label: '${context.tr('landArea')} (${context.tr('acres')})',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.landscape,
              ),
              const SizedBox(height: 14),

              // Soil Type
              Text(
                context.tr('soilType'),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSoilType,
                    items: AppConstants.soilTypes.map((st) => DropdownMenuItem(value: st, child: Text(st))).toList(),
                    onChanged: (val) => setState(() => _selectedSoilType = val ?? _selectedSoilType),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Water Source
              Text(
                context.tr('waterAvailability'),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF37474F)),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedWaterSource,
                    items: AppConstants.waterSources.map((ws) => DropdownMenuItem(value: ws, child: Text(ws))).toList(),
                    onChanged: (val) => setState(() => _selectedWaterSource = val ?? _selectedWaterSource),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              CustomTextField(
                controller: _notesController,
                label: context.tr('notes'),
                hint: 'e.g. Applied 50kg DAP, sprayed neem oil at 20 days.',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: context.tr('save'),
                icon: Icons.check,
                onPressed: _saveCrop,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
