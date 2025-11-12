import 'package:flutter/material.dart';
import 'package:flutter_layouts/theme-data.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaW = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: myThemeData,
      home: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight * 0.3;
          final w = constraints.maxWidth * 0.9;
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: _buildCard(
                ctx: context,
                hCard: h, wCard: mediaW)
              )
            );
        },
      ),
    );
  }

  _buildCard({
    required BuildContext ctx,
    required double hCard, 
    required double wCard}) {
    return SizedBox(
      height: hCard,
      width: wCard,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                '1625 Main Street',
                style: 
                TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(ctx).textTheme.labelSmall!.color
                ),
              ),
              subtitle: Text('My City, CA 99984'),
              leading: Icon(Icons.restaurant_menu, color: Colors.blue[500]),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  _gridViewExample() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Image.network("https://picsum.photos/200");
      },
    );
  }

  _ColumnListViewExample() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Texto 1', style: TextStyle(fontSize: 32)),
        Text('Texto 2', style: TextStyle(fontSize: 32)),
        SizedBox(
          height: 100,
          child: ListView(
            children: [
              Text('Texto 3', style: TextStyle(fontSize: 32)),
              Text('Texto 4', style: TextStyle(fontSize: 32)),
              Text('Texto 5', style: TextStyle(fontSize: 32)),
              Text('Texto 6', style: TextStyle(fontSize: 32)),
              Text('Texto 7', style: TextStyle(fontSize: 32)),
            ],
          ),
        ),
      ],
    );
  }
}
