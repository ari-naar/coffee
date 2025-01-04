import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coffee_shops_provider.dart';
import '../models/coffee_shop.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch coffee shops when the screen loads
    Future.microtask(
        () => context.read<CoffeeShopsProvider>().fetchCoffeeShops());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoffeeTrack'),
      ),
      body: Consumer<CoffeeShopsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                'Error: ${provider.error}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            );
          }

          if (provider.shops.isEmpty) {
            return Center(
              child: Text(
                'No coffee shops found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.shops.length,
            itemBuilder: (context, index) {
              final shop = provider.shops[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  leading: shop.imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(shop.imageUrl!),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.coffee),
                        ),
                  title: Text(shop.name),
                  subtitle: Text(shop.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        shop.rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: Navigate to coffee shop details
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add coffee shop screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
