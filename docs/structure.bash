meu_app/
├── android/                # Código nativo Android
├── ios/                    # Código nativo iOS
├── lib/                    # Código Dart do app
│   ├── main.dart           # Arquivo principal do app
│   ├── src/                # Código fonte do app
│   │   ├── core/           # Configuração global: Dio, Env, AppConfig, etc.
│   │   ├── models/         # Classes de modelo/dados
│   │   ├── services/       # Lógica de negócio, chamadas API, etc
│   │   ├── controllers/    # Controllers, bloc, providers, ou gerenciadores de estado
│   │   ├── views/          # Telas e widgets de UI
│   │   │   ├── screens/    # Telas principais do app
│   │   │   ├── widgets/    # Widgets reutilizáveis
│   │   ├── utils/          # Funções utilitárias, helpers, constantes
│   │   ├── routes/         # Configuração de rotas
│   │   ├── themes/         # Definição de temas e estilos
├── test/                   # Testes automatizados
├── pubspec.yaml            # Dependências e configuração do projeto
└── README.md