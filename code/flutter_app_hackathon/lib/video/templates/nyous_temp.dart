import 'package:flutter/material.dart';

class NyousTemplate extends StatefulWidget {
  const NyousTemplate({
    super.key,
    this.children = const <Widget>[],
  });

  final List<Widget> children;

  @override
  State<NyousTemplate> createState() => _NyousTemplateState();
}

class _NyousTemplateState extends State<NyousTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        children: [
          //* TOP SECTION: Logo
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
    
            child: Image(
              image: AssetImage('assets/logo_transparent.png'),
              height: MediaQuery.of(context).size.height * 0.08
            ),
          ),

          Column(children: widget.children.toList()),
        ],
      ),
    );
  }
}