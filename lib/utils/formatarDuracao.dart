// Função utilitária para formatar o tempo da viagem como hh:mm:ss
String formatarDuracao(Duration duration) {
  String doisDigitos(int n) => n.toString().padLeft(2, '0');
  String horas = doisDigitos(duration.inHours);
  String minutos = doisDigitos(duration.inMinutes.remainder(60));
  String segundos = doisDigitos(duration.inSeconds.remainder(60));
  return '$horas:$minutos:$segundos';
}
