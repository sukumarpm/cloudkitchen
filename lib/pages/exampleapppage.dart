import 'package:flutter/material.dart';
import 'package:toggle_list/toggle_list.dart';

const Color appColor = Colors.green;

class ExampleAppPage extends StatefulWidget {
  const ExampleAppPage({super.key});

  @override
  State<ExampleAppPage> createState() => _ExampleAppPageState();
}

class _ExampleAppPageState extends State<ExampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Toggle List Example'),
      //   foregroundColor: Colors.white,
      //   backgroundColor: appColor,
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: 
        ToggleList(
          divider: const SizedBox(height: 10),
          toggleAnimationDuration: const Duration(milliseconds: 400),
          scrollPosition: AutoScrollPosition.begin,
          trailing: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.expand_more),
          ),
          children: List.generate(
            30,
            (index) => ToggleListItem(
              leading: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.sailing),
              ),
              title: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hiding a square inside:',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 17),
                    ),
                    Text(
                      '$index^2',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              divider: const Divider(
                color: Colors.white,
                height: 2,
                thickness: 2,
              ),
              content: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  color: appColor.withOpacity(0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$index^2 is ${index * index}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Properties of n^2:\nGeometric figure: parabola\nRoot: n=0\nDiscriminant: Δ = 0\nParity: even',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      color: Colors.white,
                      height: 2,
                      thickness: 2,
                    ),
                    OverflowBar(
                      alignment: MainAxisAlignment.spaceAround,
                      // buttonHeight: 32.0,
                      // buttonMinWidth: 90.0,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Column(
                            children: [
                              Icon(Icons.add),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Text('Add offset'),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Column(
                            children: [
                              Icon(Icons.edit),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Text('Draw plot'),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Column(
                            children: [
                              Icon(Icons.save),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Text('Export plot'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onExpansionChanged: _expansionChangedCallback,
              headerDecoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              expandedHeaderDecoration: const BoxDecoration(
                color: appColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _expansionChangedCallback(int index, bool newValue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Changed expansion status of item  no.${index + 1} to ${newValue ? "expanded" : "shrunk"}.',
        ),
      ),
    );
  }
}
