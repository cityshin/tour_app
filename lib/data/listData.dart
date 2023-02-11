import 'package:flutter/material.dart';

class Item{
  String title;
  int value;
  Item(this.title, this.value);
}

class Area {
  List<DropdownMenuItem<Item>> seoulArea = List.empty(growable: true);

Area() {
  seoulArea.add(DropdownMenuItem(child: Text('강남구'),value: Item('강남구',1),));
  seoulArea.add(DropdownMenuItem(child: Text('강동구'),value: Item('강동구',2),));
  seoulArea.add(DropdownMenuItem(child: Text('강북구'),value: Item('강북구',3),));
  seoulArea.add(DropdownMenuItem(child: Text('강서구'),value: Item('강서구',4),));
  seoulArea.add(DropdownMenuItem(child: Text('마포구'),value: Item('마포구',5),));
  seoulArea.add(DropdownMenuItem(child: Text('서초구'),value: Item('서초구',6),));
  seoulArea.add(DropdownMenuItem(child: Text('구로구'),value: Item('구로구',7),));

}
}

class Kind {
  List<DropdownMenuItem<Item>> kinds = List.empty(growable: true);

  Kind() {
    kinds.add(DropdownMenuItem(
      child: Text('관광지'),
      value: Item('관광지', 12),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('문화시설'),
      value: Item('문화시설', 14),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('축제/공연'),
      value: Item('축제/공연', 15),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('여행코스'),
      value: Item('여행코스', 25),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('레포츠'),
      value: Item('레포츠', 28),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('숙박'),
      value: Item('숙박', 32),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('쇼핑'),
      value: Item('쇼핑', 38),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('음식'),
      value: Item('음식', 39),
    ));
    kinds.add(DropdownMenuItem(
      child: Text('전체'),
      value: Item('전체', 0),
    ));
  }
}