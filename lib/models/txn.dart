class Txn {
  final int? id;
  final int userId;
  final String datetime;
  final double total;
  final String location;
  final String status;

  Txn({
    this.id,
    required this.userId,
    required this.datetime,
    required this.total,
    required this.location,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'datetime': datetime,
      'total': total,
      'location': location,
      'status': status,
    };
  }

  factory Txn.fromMap(Map<String, dynamic> map) {
    return Txn(
      id: map['id'],
      userId: map['user_id'],
      datetime: map['datetime'],
      total: map['total'],
      location: map['location'] ?? 'No Location',
      status: map['status'],
    );
  }
}