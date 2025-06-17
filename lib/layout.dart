import 'package:flutter/material.dart';

class ChildWidget extends StatefulWidget {
  final Function callback;
  const ChildWidget({Key? key, required this.callback}) : super(key: key);

  @override
  State<ChildWidget> createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> with SingleTickerProviderStateMixin {

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'One'),
    Tab(text: 'Two'),
    Tab(text: 'Three'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
        length: tabs.length
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: tabs.map((Tab tab) {
          return createTab(tab);
        }).toList(),
      ),
    );
  }

  Widget createTab(Tab tab) {
    return Center(
        child: Text(
          'This is "${tab.text}" Tab.',
          style: const TextStyle(
            fontSize: 32.0,
            color: Colors.blue,
          ),
        )
    );
  }
}
