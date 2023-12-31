import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_form/cart_model.dart';
import 'package:test_form/db_helper.dart';

import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
       appBar: AppBar(title: const Text('Orders'),
      backgroundColor: Color.fromARGB(255, 234, 187, 146),
      centerTitle: true,
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
        Center(
          child: Badge(
            badgeContent: Consumer<CartProvider>(
              builder: ((context, value, child) {
                return Text(value.getCoubter().toString(),style: TextStyle(color: Colors.white));
              }),
            ),
            child: const Icon(Icons.shopping_bag_outlined,color: Colors.black),
          ),
        ),
        SizedBox(width: 20.0)
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context , AsyncSnapshot<List<Cart>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return Center(
                    child: Image.asset('assets/images/logo1.png')
                  );
                }else {

                }
                return Expanded(
                  child: ListView.builder(
          itemCount:snapshot.data!.length,
          itemBuilder: (context, index){
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                  children: [
                    Image(height:100, width: 200,
                    image: NetworkImage(snapshot.data![index].image.toString()),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text(snapshot.data![index].productName.toString(),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                         InkWell(
                          onTap: (){
                            dbHelper!.delete(snapshot.data![index].id!);
                            cart.removerCounter();
                            cart.removerTotalPrice(double.parse(snapshot.data![index].price.toString()));
                          },
                          // ignore: prefer_const_constructors
                           child: const Icon(Icons.delete, color: Colors.red,)
                          ),
                          ],
                         ),
                      const SizedBox(height: 5,),
                      Text(snapshot.data![index].unitTag.toString() + " " + r"$"+ " "+ snapshot.data![index].price.toString() + " "+'Bath',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                          },
                          
                          child: Container(
                            height: 40,
                            width: 90,
                            decoration: BoxDecoration(color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                    InkWell(
                                      onTap: () {
                                        int quantity = snapshot.data![index].quantity!;
                                        int price = snapshot.data![index].initialPrice!;
                                        quantity--;
                                        int? newPrice = price * quantity;
                                        if(quantity > 0) {
                                         dbHelper!.updateQuanity(
                                          Cart(id: snapshot.data![index].id!,
                                           productId: snapshot.data![index].productId!.toString(),
                                            productName: snapshot.data![index].productName!,
                                             initialPrice: snapshot.data![index].initialPrice!,
                                              price: newPrice, 
                                              quantity: quantity, 
                                              unitTag: snapshot.data![index].unitTag.toString(),
                                               image: snapshot.data![index].image.toString())
                                        ).then((value) {
                                            newPrice = 0;
                                            quantity = 0;
                                            cart.removerTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                        }).onError((error, stackTrace){
                                          print(error.toString());
                                        });
                                        }
                                      },
                                      
                                      
                                      child: Icon((Icons.remove),color: Colors.white,)),
                                    Text(snapshot.data![index].quantity.toString() , style: TextStyle(color: Colors.white)),
                                     InkWell(
                                      onTap: (){
                                        int quantity = snapshot.data![index].quantity!;
                                        int price = snapshot.data![index].initialPrice!;
                                        quantity++;
                                        int? newPrice = price * quantity;
                                        dbHelper!.updateQuanity(
                                          Cart(id: snapshot.data![index].id!,
                                           productId: snapshot.data![index].productId!.toString(),
                                            productName: snapshot.data![index].productName!,
                                             initialPrice: snapshot.data![index].initialPrice!,
                                              price: newPrice, 
                                              quantity: quantity, 
                                              unitTag: snapshot.data![index].unitTag.toString(),
                                               image: snapshot.data![index].image.toString())
                                        ).then((value) {
                                            newPrice = 0;
                                            quantity = 0;
                                            cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                        }).onError((error, stackTrace){
                                          print(error.toString());
                                        });
                                      },
                                      child: Icon((Icons.add),color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      ],),
                    ),    
                  ],
                )
              ]),
            ),
          );
         },),);
              }
              return Text('data');
            }), 
          Consumer <CartProvider>(builder: (context, value, child) {
          return Visibility(
            visible: value.getTotalPrice().toStringAsFixed(2) =="0.00" ? false : true,
            child: Column(
              children: [
                ReusableWidget(title: 'Sub Total', value: r'$'+value.getTotalPrice().toStringAsFixed(2),),
                ReusableWidget(title: 'Discout 5%', value: r'$'+'20',),
                ReusableWidget(title: 'Total', value: r'$'+value.getTotalPrice().toStringAsFixed(2),)
              ],
            ),
          );
        })
     
        ]),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title ,  value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString(), style: Theme.of(context).textTheme.subtitle2,)
        ],
      ),
    );
  }
}