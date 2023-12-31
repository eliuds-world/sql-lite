class Person implements Comparable<Person> {
  final int id;
  final String firstName;
  final String lastName;

  const Person({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

//sqllite deseralization
  Person.fromRow(Map<String, Object?> row)
      : id = row['ID'] as int,
        firstName = row['FIRST_NAME'] as String,
        lastName = row['LAST_NAME'] as String;
  @override
  int compareTo(covariant Person other) {
    return id.compareTo(other.id);
  }

  @override
  bool operator ==(covariant Person other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Person , id = $id ,firstName: $firstName, lastName: $lastName';
  }
}
