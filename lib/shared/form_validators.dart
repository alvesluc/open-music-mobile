class FormValidators {
  static String? validateNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return "O campo não pode ser vazio.";
    }
    return null;
  }
}
