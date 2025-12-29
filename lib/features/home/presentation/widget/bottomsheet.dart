// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  final VoidCallback onTap;
  const BottomSheetWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 8),

              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded, color: Colors.black),
                        SizedBox(width: 12),
                        Text(
                          "Where do you want to go?",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),

                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Recent Search',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                
              )
            ],
          ),
        );
      },
    );
  }
}
