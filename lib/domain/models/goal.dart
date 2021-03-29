import 'package:habbits_manager/domain/models/habbit.dart';

class Goal {
  int id;
  String name;
  String description;
  DateTime creationDate;
  List<Habbit> habbits;

  Goal({
    this.id,
    this.name,
    this.description,
    this.creationDate,
    this.habbits,
  });
}
