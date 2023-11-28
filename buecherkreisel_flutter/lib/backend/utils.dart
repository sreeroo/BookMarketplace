List<dynamic> mergeListsOnKey(
    List<dynamic> list_a, List<dynamic> list_b, String keyPath) {
  for (final (index_b, obj) in list_b.indexed) {
    for (final (index_a, merge_obj) in list_a.indexed) {
      if (obj[keyPath] == merge_obj[keyPath]) {
        list_a[index_a] = list_b[index_b];
        list_b.removeAt(index_b);
        break;
      }
    }
  }
  for (final left_over in list_b) list_a.add(left_over);
  return list_a;
}
