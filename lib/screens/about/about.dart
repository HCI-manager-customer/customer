// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../misc/flip_stock.dart';
import '../misc/flip_stock.dart';

class AboutUs {
  final String name;
  final String url;
  const AboutUs({
    required this.name,
    required this.url,
  });
}

class MyTeam {
  static const m1 = AboutUs(
    name: 'Dien Cao',
    url:
        'https://scontent-hkg4-1.xx.fbcdn.net/v/t39.30808-6/240650438_1493318801051183_4179764199109439838_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=wqy4ZlYWexwAX-G7ZkW&tn=OGlCu8tEhPhhGwlL&_nc_ht=scontent-hkg4-1.xx&oh=00_AT-CpqwzFQ5uA445h0hmjFRzReglodKAGJJbHkGIJOabew&oe=628F27B6',
  );
  static const m2 = AboutUs(
    name: 'Phạm Thương',
    url:
        'https://scontent-hkg4-2.xx.fbcdn.net/v/t39.30808-1/279367915_2109918329185720_9199987224835987791_n.jpg?stp=dst-jpg_s200x200&_nc_cat=104&ccb=1-7&_nc_sid=7206a8&_nc_ohc=MZidUMRt3dwAX93ssc4&_nc_ht=scontent-hkg4-2.xx&oh=00_AT9jnPeh-rk4Qvn-0ZUj2WS-P00Q0N4bzlCOlFLIF5F9fw&oe=628EC596',
  );
  static const m3 = AboutUs(
    name: 'Triệu Quốc Doanh',
    url:
        'https://scontent-hkg4-1.xx.fbcdn.net/v/t39.30808-1/280708406_1129956101182909_3161369117057570103_n.jpg?stp=dst-jpg_p200x200&_nc_cat=103&ccb=1-7&_nc_sid=7206a8&_nc_ohc=E5YbyU-uguwAX9e_Wq-&_nc_ht=scontent-hkg4-1.xx&oh=00_AT8WDb6FCgXKXDBVOcoC7djqf8jIbzZgb_l_S_p5fEB_6A&oe=628FF7B4',
  );
  static const m4 = AboutUs(
    name: 'Tùng Nguyễn',
    url:
        'https://scontent-hkg4-2.xx.fbcdn.net/v/t39.30808-6/279643816_177402754630021_5114462357707501129_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=L_ymfBRDuIcAX9Vw_uA&tn=OGlCu8tEhPhhGwlL&_nc_ht=scontent-hkg4-2.xx&oh=00_AT9U1fq2UE0xhD4Tfgd2ES7QszjaHeGe8XYlnD1vbLoRKA&oe=628ED5A5',
  );
  static const m5 = AboutUs(
    name: 'Chánh Đức',
    url: 'https://i.ibb.co/LRhZjym/20220511-121423.jpg',
  );

  static const all = <AboutUs>[m1, m2, m3, m4, m5];
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          title: const Text('About Us'),
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [...MyTeam.all.map(printMember).toList()],
        ),
      ),
    );
  }

  Widget printMember(AboutUs u) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CircleAvatar(
              child: Image.network(
                u.url,
                cacheHeight: 500,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: FlipStock(),
                  );
                },
              ),
            ),
          ),
          title: Text(u.name),
        ),
      ),
    );
  }
}
