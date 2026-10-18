import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/crop_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/crop_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../app/routes.dart';

class MyCropsScreen extends StatelessWidget {
  const MyCropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cropProv = Provider.of<CropProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('myCropsTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Crop',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addCrop),
          ),
        ],
      ),
      body: cropProv.crops.isEmpty
          ? EmptyStateView(
              icon: Icons.grass,
              title: 'No Crops Registered Yet',
              message: 'Add your active crops to receive stage-specific fertilizer advice and pest alerts.',
              buttonText: context.tr('addCrop'),
              onButtonPressed: () => Navigator.pushNamed(context, AppRoutes.addCrop),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: cropProv.crops.length,
              itemBuilder: (context, idx) {
                final crop = cropProv.crops[idx];
                return CropCard(
                  crop: crop,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.cropDetail,
                      arguments: crop.id,
                    );
                  },
                  onAskAi: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.home, // routes to chat with pre-selected crop
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addCrop),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          context.tr('addCrop'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
