import 'package:fitcpxaluno/src/blocs/events/calendar_bloc.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_event.dart';
import 'package:fitcpxaluno/src/blocs/events/calendar_state.dart';
import 'package:fitcpxaluno/src/screens/view_payment_contract.dart';
import 'package:fitcpxaluno/src/services/calendar_service.dart';
import 'package:fitcpxaluno/src/widgets/cupertino_card.dart';
import 'package:fitcpxaluno/src/widgets/customScaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int _selectedSegment = 0;

  Widget build(BuildContext context) {
    return CustomScaffold(
      navigationBar: const CupertinoNavigationBar(
        border: null,
        middle: Text('Eventos'),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: CupertinoColors.tertiarySystemFill,
                  thumbColor: CupertinoColors.systemBackground.resolveFrom(
                    context,
                  ),
                  groupValue: _selectedSegment,
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Meus Agendamentos',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Disponíveis',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  },
                  onValueChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSegment = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarLoading) {
                  return const Expanded(
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                } else if (state is CalendarError) {
                  return Expanded(child: Center(child: Text(state.message)));
                } else if (state is CalendarLoaded) {
                  // Decide qual lista passar baseado no segmento selecionado
                  final eventsToShow = _selectedSegment == 0
                      ? state.events
                      : state.avaliableEvents;

                  if (eventsToShow.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.calendar_badge_minus,
                              size: 50,
                              color: CupertinoColors.systemGrey.withOpacity(
                                0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _selectedSegment == 0
                                  ? 'Nenhum agendamento encontrado'
                                  : 'Nenhum evento disponível',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Renderiza a lista (Reutilizando código)
                  return _buildEventList(eventsToShow, context);
                }
                return const Expanded(
                  child: Center(child: CupertinoActivityIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildEventList(List<dynamic> events, context) {
  Future<void> _launchUrl(String url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      showCupertinoSnackBar(context, 'Não foi possível abrir o link');
    }
  }

  void _optionsEventModal(eventUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que o modal ocupe o tamanho necessário
      backgroundColor:
          Colors.transparent, // Transparente para usar o estilo Cupertino
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                ),
                const Text(
                  "Meu agendamento",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: const Text("Solicitar ajuste"),
                    onPressed: () {
                      // _launchUrl("https://wa.me/554498084028");
                      _launchUrl(eventUrl);
                      // Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _optionsEventAvaliableModal(eventId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que o modal ocupe o tamanho necessário
      backgroundColor:
          Colors.transparent, // Transparente para usar o estilo Cupertino
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                ),
                const Text(
                  "Evento disponível",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: const Text("Agendar esse evento"),
                    onPressed: () async {
                      await CalendarService().scheduleEvent(eventId, context);
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Agendado com successo'),
                          content: Text(
                            "O responsável do evento foi notificado",
                          ),
                          actions: [
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () {
                                context.read<CalendarBloc>().add(
                                  LoadCalendar(),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  return Expanded(
    child: ListView.builder(
      // Adiciona padding bottom para não colar no fim da tela
      padding: const EdgeInsets.only(bottom: 40),
      itemCount: events.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final event = events[index];

        return CupertinoCard(
          onTap: () => event.studentId != null
              ? _optionsEventModal(event.url)
              : _optionsEventAvaliableModal(event.id),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey4.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(FontAwesomeIcons.calendar, size: 15),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(context, 'Modalidade:', event.modalidade),
                    _buildInfoRow(context, 'Descrição:', event.description),
                    _buildInfoRow(context, 'Início:', event.startDate),
                    _buildInfoRow(context, 'Fim:', event.endDate),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: CupertinoColors.systemGrey,
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Pequeno helper para os textos das linhas
Widget _buildInfoRow(BuildContext context, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Text(
      '$label ${value.isNotEmpty ? value : "-"}',
      style: TextStyle(
        fontSize: 13, // Ajustei levemente para caber melhor
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      ),
    ),
  );
}
