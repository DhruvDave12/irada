import 'package:freezed_annotation/freezed_annotation.dart';
part 'contact.freezed.dart';

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    String? description,
  }) = _Contact;

  Map<String, dynamic> toMap(Contact contact) {
    return {
      'id': contact.id,
      'name': contact.name,
      'description': contact.description,
    };
  }
}
