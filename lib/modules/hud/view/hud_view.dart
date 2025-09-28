import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:velocimetro_flutter/modules/hodometro/viewmodels/viagem_viewmodel.dart';
import 'package:velocimetro_flutter/utils/formatarDuracao.dart';
import 'package:velocimetro_flutter/widgets/action_button.dart';
import 'package:velocimetro_flutter/widgets/info_card.dart';
import 'package:velocimetro_flutter/widgets/velocimetro_widget.dart';

class HudView extends StatefulWidget {
  const HudView({super.key});

  @override
  State<HudView> createState() => _HudViewState();
}

class _HudViewState extends State<HudView> {
  @override
  void initState() {
    super.initState();
    // Inicializa o ViewModel e solicita permissões de localização logo após o carregamento da tela
    Future.delayed(Duration.zero, () {
      Provider.of<ViagemViewModel>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    final screenWidth = MediaQuery.of(context).size.width;
    final colWidth = (screenWidth * 0.55).clamp(300.0, 700.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: const Text('Modo HUD'),
        elevation: 0, // Sem sombra
        centerTitle: true, // Título centralizado
      ),

      // Consumer para escutar o TripViewModel
      body: Consumer<ViagemViewModel>(
        builder: (context, ViagemViewModel, child) {
          // Se não tiver permissão de localização, exibe aviso
          if (!ViagemViewModel.permissaoLocalizacao) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_disabled,
                    size: 60,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Permissão de localização necessária',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    // Solicita permissão novamente
                    onPressed: () =>
                        ViagemViewModel.solicitarPermissaoLocalizacao(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Solicitar Permissão'),
                  ),
                ],
              ),
            );
          }

          // Se tiver permissão, exibe os dados do velocímetro e viagem
          return Container(
            color: Color.fromARGB(255, 0, 0, 0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.1416),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * .4,
                          child: VelocimetroWidget(
                            velocidade: ViagemViewModel.velocidade,
                            velocidadeMax: 180,
                          ),
                        ),

                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: screenWidth * .6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: colWidth * .47,
                                    child: InfoCard(
                                      dark: true,
                                      title: 'Distância',
                                      value:
                                          '${ViagemViewModel.distancia.toStringAsFixed(2)} km',
                                      icon: Icons.straighten,
                                      color: Colors.green.shade400,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: colWidth * .47,
                                    child: InfoCard(
                                      dark: true,
                                      title: 'Vel. Média',
                                      value:
                                          '${ViagemViewModel.velocidade.toStringAsFixed(1)} km/h',
                                      icon: Icons.speed,
                                      color: Colors.orange.shade400,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              SizedBox(
                                width: colWidth,
                                child: InfoCard(
                                  dark: true,
                                  title: 'Tempo',
                                  value: formatarDuracao(
                                    ViagemViewModel.duracaoViagem,
                                  ),
                                  icon: Icons.timer,
                                  color: Colors.blue.shade400,
                                  fullWidth: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Botões de controle (play/pause e reset)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(),
                        blurRadius: 10,
                        offset: const Offset(0, -5), // Sombra pra cima
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      // Botão de iniciar ou pausar rastreamento
                      ActionButton(
                        icon: ViagemViewModel.rastreamentoAtivo
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: ViagemViewModel.rastreamentoAtivo
                            ? Colors.orange
                            : const Color.fromARGB(255, 255, 255, 255),
                        onTap: () {
                          if (ViagemViewModel.rastreamentoAtivo) {
                            ViagemViewModel.pausarRastreamento();
                          } else {
                            ViagemViewModel.iniciarViagem();
                          }
                        },
                      ),

                      // Botão para resetar os dados
                      ActionButton(
                        icon: Icons.refresh,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        onTap: () => ViagemViewModel.retomarRastreamento(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
