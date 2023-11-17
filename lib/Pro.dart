import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_form/cart_provider.dart';
import 'package:test_form/cart_screen.dart';
import 'package:test_form/db_helper.dart';
import 'cart_model.dart';
import 'package:favorite_button/favorite_button.dart';

class ProductList extends StatefulWidget {
  const ProductList ({Key? key}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}
class _ProductListState extends State<ProductList> {
      DBHelper? dbHelper = DBHelper();
 List<String> productName = ['Bag1','Bag2','Bag3','Bag4','Bag5','Bag6','Bag7'];
      List<String> productUnit = ['','','','','','',''];
      List<int> price =[2000,2500,2450,3000,3400,2500,3400];
      List<String> productImage =[
        'https://sc04.alicdn.com/kf/H03b874b14ae046428398f51acd9c90bfu.jpg',
        'https://files.vogue.co.th/uploads/e222a033825b04f0ac97618f71c0262b.jpg',
        'https://files.vogue.co.th/uploads/1b0481eee18288d372947b63083c59e2.jpg',
        'https://backend.central.co.th/media/catalog/product/d/d/ddfa7a9f7538f0d59dd74b612c10cd4d2c9d4904_mkp0884392dummy.jpg',
        'https://img.ltwebstatic.com/images3_pi/2022/08/26/16614797358ac5f72432d3bc441b4773adae841db1_thumbnail_900x.webp',
        'https://files.vogue.co.th/uploads/646df71fff97adebc5989698efa22ef5.jpg',
        'https://files.vogue.co.th/uploads/71db853bd64b30e28373e322a9ae030c.jpg'];

     

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
     theme: ThemeData(
        fontFamily: 'Kanit',
        primarySwatch: Colors.blue,
      );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 176, 106),
      appBar: AppBar(title: Text('Shopping'),
      backgroundColor: Color.fromARGB(255, 236, 176, 106),
      centerTitle: true,
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>CartScreen()));
          },
            child: Center(
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: ((context, value, child) {
                    return Text(value.getCoubter().toString(),style: TextStyle(color: Colors.white)
                    );
                  }),
                ),
                child:  Icon(Icons.shopping_bag_outlined),
              ),
            ),
        ),
        SizedBox(width: 20.0)
      ],
      ),
    body: Column(children: [
       Expanded(
        child: ListView.builder(
        itemCount: productName.length,
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
                    Image(height:150, width: 150,
                    image: NetworkImage(productImage[index].toString()),),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productName[index].toString(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                      const SizedBox(height: 10,),
                        Text(productUnit[index].toString() + " " + r"$" +price[index].toString()+" " +'Bath',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5,),
                        Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            FavoriteButton(
                              iconSize: 30,
                           valueChanged: (_) {
            },
          ),
                          ],
                        ),
                      const SizedBox(height: 5,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                             dbHelper!.insert(
                              Cart(id : index, 
                              productId : index.toString(), 
                              productName : productName[index].toString(),
                              initialPrice :  price[index],
                              price :  price[index],
                             quantity :  1,
                            unitTag :  productUnit[index].toString(),
                            image : productImage[index].toString()
                            )
                              ).then((value) {
                                print('Product is added to cart');
                                cart.addTotalPrice(double.parse(price[index].toString()));
                                cart.addCounter();
                              }).onError((error, stackTrace){
                                print(error.toString());
                              });
                          },
                            child: Container(
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(child: Text('+' , style: TextStyle(color: Colors.white,fontSize: 18),)),
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
       },),),
     
    ],
    ),
    );
  }
}

