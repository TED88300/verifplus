import 'package:verifplus/Widget/Catalogue_Grig/category.dart';
import 'package:verifplus/Widget/Catalogue_Grig/product.dart';

class AppData {
  static List<Product> productList = [
    Product(id: 131, name: 'Eau 6 litres PA (Sans Additif)', price: 195.00, isSelected: true, isliked: false, image: 'assets/Ext_01.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 132, name: 'Eau + Additif 6 litres PA', price: 145.00, isSelected: false, isliked: true, image: 'assets/Ext_01.png', category: "01 - EXTINCTION", promo : 129),
    Product(id: 133, name: 'Eau + Additif 6 litres PP (EXPER)', price: 155.00, isSelected: false, isliked: true, image: 'assets/Ext_02.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 134, name: 'Eau + Additif 6 Litres ABF - BIOVERSAL ECOLOGIQUE', price: 225.00, isSelected: false, isliked: true, image: 'assets/Ext_03.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 146, name: 'Eau + Additif 50 litres sur roues PP', price: 1350.00, isSelected: false, isliked: true, image: 'assets/Ext_04.png', category: "01 - EXTINCTION", promo : 1100),
    Product(id: 109, name: 'ABC 3 kilos PP (EXPER)', price: 95.00, isSelected: false, isliked: false, image: 'assets/Ext_05.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 151, name: 'CO2 2 kilos - Dioxyde de carbone', price: 175.00, isSelected: false, isliked: false, image: 'assets/Ext_06.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 154, name: 'CO2 5 kilos - Dioxyde de carbone', price: 395.00, isSelected: false, isliked: false, image: 'assets/Ext_07.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 154, name: 'CO2 5 kilos - Dioxyde de carbone', price: 395.00, isSelected: false, isliked: false, image: 'assets/Ext_07.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 157, name: 'CO2 10 Kilos sur roues', price: 1500.00, isSelected: false, isliked: false, image: 'assets/Ext_07.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 158, name: 'CO2 20 Kilos sur roues', price: 3000.00, isSelected: false, isliked: false, image: 'assets/Ext_08.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 158, name: 'CO2 20 Kilos sur roues', price: 3000.00, isSelected: false, isliked: false, image: 'assets/Ext_09.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 420, name: 'Joint torique de percuteur - Gamme SILICE 3e - SICLI', price: 15.00, isSelected: false, isliked: false, image: 'assets/P_01.png', category: "04 - PIÈCES DÉTACHÉES", promo : 0),
    Product(id: 455, name: 'Joint de tête 60 X 4', price: 10.00, isSelected: false, isliked: false, image: 'assets/P_02.png', category: "04 - PIÈCES DÉTACHÉES", promo : 0),
    Product(id: 702, name: 'RIA DN 19/20M Tournant et Pivotant - Diffuseur DMFA - EUR5', price: 600.00, isSelected: false, isliked: false, image: 'assets/RIA_01.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 703, name: 'RIA DN 25/20 Pivotant en INOX - Diffuseur DMFA', price: 2300.00, isSelected: false, isliked: false, image: 'assets/RIA_02.png', category: "01 - EXTINCTION", promo : 0),
    Product(id: 760, name: 'PIA DN 33/20 Tournant et Pivotant 360°', price: 3000.00, isSelected: false, isliked: false, image: 'assets/RIA_03.png', category: "01 - EXTINCTION", promo : 2500),
  ];
  static List<Product> cartList = [
    Product(id: 158, name: 'CO2 20 Kilos sur roues', price: 3000.00, isSelected: false, isliked: false, image: 'assets/Ext_07.png', category: "01 - EXTINCTION"),
    Product(id: 420, name: 'Joint torique de percuteur - Gamme SILICE 3e - SICLI', price: 15.00, isSelected: false, isliked: false, image: 'assets/P_01.png', category: "04 - PIÈCES DÉTACHÉES"),
    Product(id: 760, name: 'PIA DN 33/20 Tournant et Pivotant 360°', price: 3000.00, isSelected: false, isliked: false, image: 'assets/RIA_03.png', category: "01 - EXTINCTION"),
  ];
  static List<Category> categoryList = [

    Category(id: 1, name: "01 - EXTINCTION", image: 'assets/Ext_01.png', isSelected: true),
    Category(id: 2, name: "04 - PIÈCES DÉTACHÉES", image: 'assets/P_01.png'),

  ];
  static String description = "Utilisation: Classe de feu A uniquement\nClasse A\nBois, papier, tissu, carton, ...\nA ­ Feux « secs » ou « braisants »\nFeux de matériaux solides formant des braises";
}
