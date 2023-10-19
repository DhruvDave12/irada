import 'package:freezed_annotation/freezed_annotation.dart';
part 'record.freezed.dart';

@freezed
class Record with _$Record {
  const factory Record({
    required String id,
    required String contactId,
    required String title,
    required String address,
  }) = _Record;

  Map<String, dynamic> toMap(Record record) {
    return {
      'id': record.id,
      'contactId': record.contactId,
      'title': record.title,
      'address': record.address,
    };
  }
}
