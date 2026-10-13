<p align="right">
  <a href="README.md">🇺🇸 English</a> · <a href="README.pt-BR.md"><strong>🇧🇷 Português</strong></a>
</p>

<p align="center">
  <img src="assets/images/logo.png" alt="Logo do FitCPX" width="96" />
</p>

<h1 align="center">FitCPX · Aplicativo do Aluno</h1>

<p align="center">
  <strong>O aplicativo Flutter para alunos de uma plataforma SaaS real de gestão fitness.</strong>
</p>

<p align="center">
  <a href="https://fitcpx.com">Produto oficial</a> ·
  <a href="https://github.com/Allyyssoonnn/fitcpx-web">Aplicação web</a> ·
  <a href="https://github.com/Allyyssoonnn/fitcpx-backend">API Backend</a>
</p>

<p align="center">
  <code>Flutter</code> &nbsp; <code>Dart</code> &nbsp; <code>BLoC</code> &nbsp;
  <code>Dio</code> &nbsp; <code>Firebase</code> &nbsp; <code>Android e iOS</code>
</p>

---

## Sobre o aplicativo

O **FitCPX – Aluno** é o aplicativo destinado aos alunos dentro do ecossistema FitCPX. Ele conecta os usuários aos treinos, avaliações físicas, atividades agendadas, mensagens e contratos gerenciados pela plataforma principal.

Desenvolvido em Flutter e Dart para Android e iOS, o aplicativo organiza a navegação em cinco áreas: **Início, Avaliações, Treinos, Chat e Conta**.

## Funcionalidades

- **Treinos e sessões:** acesso aos treinos atribuídos, detalhes dos exercícios, acompanhamento de sessões e registro de progresso.
- **Histórico de treinos:** consulta às sessões anteriores e compartilhamento de resumos.
- **Avaliações físicas:** visualização de medidas, acompanhamento da evolução, imagens de progresso e envio de avaliações.
- **Agenda:** visualização de eventos e solicitação de participação pelo calendário.
- **Chat:** troca de mensagens por meio do backend FitCPX.
- **Contratos:** consulta aos contratos dos alunos e informações relacionadas a pagamentos.
- **Cronômetros e notificações:** timers de treino, alertas locais e notificações push com Firebase Cloud Messaging.
- **Autenticação:** login do aluno, gerenciamento de conta e recuperação de senha.

A disponibilidade de recursos depende da conta do aluno e dos serviços habilitados pelo profissional ou pela organização FitCPX.

## Tecnologias

| Área | Tecnologia |
| --- | --- |
| Aplicativo | Flutter, Dart |
| Gerenciamento de estado | `flutter_bloc` |
| Navegação | `go_router`, interface Cupertino |
| Comunicação HTTP | Dio, interceptors |
| Mensagens e notificações | Firebase Cloud Messaging, Flutter Local Notifications |
| Persistência local | Shared Preferences, SQLite |
| Relatórios e compartilhamento | PDF/printing, `share_plus` |
| Mídia e gráficos | Cached Network Image, gráficos, reprodução de vídeos |

## Estrutura do projeto

```text
lib/
├── main.dart               # Inicialização, Firebase e providers
└── src/
    ├── blocs/             # Estados e eventos da aplicação
    ├── core/              # Cliente HTTP e interceptors
    ├── models/            # Modelos de dados
    ├── routes/            # Navegação
    ├── screens/           # Telas de funcionalidades
    ├── services/          # Comunicação com a API FitCPX
    ├── utils/             # Ambientes e utilitários
    ├── views/             # Abas principais e autenticação
    └── widgets/           # Componentes reutilizáveis
android/                   # Aplicativo Android
ios/                       # Aplicativo iOS
assets/                    # Imagens, áudios e templates
```

## Configuração e desenvolvimento local

Este aplicativo **faz parte da plataforma FitCPX** e não funciona de maneira independente: é necessário um backend compatível e uma conta de aluno válida para utilizar recursos autenticados.

1. Instale uma versão compatível do Flutter (o projeto declara Dart SDK `^3.8.1`).
2. Execute `flutter pub get` na raiz do repositório.
3. Configure o Firebase para os aplicativos Android/iOS que serão executados. Os arquivos nativos `google-services.json` e `GoogleService-Info.plist` contêm configuração de **cliente**, não chaves privadas de conta de serviço. Para uma implantação separada, utilize seu próprio projeto Firebase e restrinja as chaves conforme necessário.
4. Revise `lib/src/utils/variables.dart` **antes de executar**. O projeto está configurado por padrão para a API de produção do FitCPX. Para desenvolvimento, selecione um backend isolado e uma conta de teste; não faça experimentos com dados de produção.
5. Após selecionar um ambiente seguro, execute `flutter run` em um dispositivo Android ou iOS configurado.

### Assinatura de versões Android

O projeto utiliza `android/key.properties` para configurar a assinatura de versões Android. Senhas, keystores, certificados e esse arquivo são privados e não devem ser versionados. O arquivo `android/key[example].properties` demonstra os campos esperados e pode ser usado para criar uma cópia local privada.

## Repositórios relacionados

- **[fitcpx-web](https://github.com/Allyyssoonnn/fitcpx-web)** — plataforma web.
- **[fitcpx-backend](https://github.com/Allyyssoonnn/fitcpx-backend)** — serviços e APIs consumidos pelo aplicativo.

O aplicativo independente de biblioteca de exercícios é outro projeto do ecossistema FitCPX e não integra este repositório.

## Histórico de desenvolvimento

Este repositório preserva o histórico original de desenvolvimento do aplicativo, iniciado em **julho de 2025**. O código representa a evolução de um produto comercial, e não apenas um projeto demonstrativo.

## Licença

Nenhuma licença de código aberto foi atribuída ao projeto até o momento. A disponibilidade pública do código não autoriza automaticamente sua redistribuição ou utilização comercial.
