class Contact{
  final int id;
  final String name;
  final String surname;
  final String phone;
  Contact({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone
  });

  factory Contact.fromSqfliteDatabase(Map<String, dynamic> map) => Contact(
    id: map['id']?.toInt() ?? 0,
    name: map['name'] ?? '',
    surname: map['surname'] ?? '',
    phone: map['phone'] ?? ''
  );
}