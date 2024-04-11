import 'dart:convert';

import 'package:chat/core/message_const.dart';

typedef CheckCallback<T> = bool Function(T previous, T next);
typedef CreateCallback<T> = T Function(T previous, T next);

class ContentUtils<T> {
  Iterable<T> mergeContent({
    required Iterable<T> contents,
    required CheckCallback<T> check,
    required CreateCallback<T> create,
  }) {
    if (contents.isEmpty || contents.length == 1) {
      return contents;
    }
    List<T> merged = [];
    T? previousContent;
    for (var content in contents) {
      if (previousContent != null && check(previousContent, content)) {
        previousContent = create(previousContent, content);
      } else {
        if (previousContent != null) {
          merged.add(previousContent);
        }
        previousContent = content;
      }
    }
    if (previousContent != null) {
      merged.add(previousContent);
    }

    return merged;
  }
}

extension StringExtensions on String {
  String prepareQuestion() {
    return stopSequences.contains(this[length - 1]) ? this : '$this?';
  }

  String prepareAnswer({String prompt = ''}) {
    return replaceAll('Prompt:\n$prompt\nOutput:\n', '').replaceAll('*', '').replaceAll('\n', '');
  }

  String latinToUtf() {
    return utf8.decode(latin1.encode(this));
  }
}
