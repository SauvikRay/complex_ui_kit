import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'first_screen_controller.dart';

class MyFirstScreen extends StatelessWidget {
  const MyFirstScreen({super.key, this.appbarName});

 final String? appbarName;

  @override
  Widget build(BuildContext context) {
    Get.put(FirstScreenController());

        return Scaffold(
          appBar:AppBar(
            
            title: Text(appbarName??'First Scrren'),
          ) ,
        
          body: Center(
            child: Column(children: [
            
            GetBuilder<FirstScreenController>(
              id: 'increment',
              builder: (FirstScreenController controller ) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                         IconButton(onPressed: () {
                    controller.increse();
                  },
                  icon: Icon(Icons.add),
                  ), 
                  SizedBox(width: 20,),
                  
                  Text('${controller.increment}'),
                        
                  SizedBox(width: 20,),
                   IconButton(onPressed: () {
                            controller.decrement();
                  },
                  icon: Icon(Icons.remove),
                  ),
                ],);
              }
            ),
           
            ],),
          ),
        
        );
   
  }
}