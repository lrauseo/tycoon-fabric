# Factory Tycoon - AI Coding Instructions

## 🎮 Project Overview
**Flutter + Flame 2.5D isometric factory tycoon game** where players build production lines with conveyors, machines, and junctions to manufacture and sell items for profit.

- **Platform:** Mobile (iOS/Android)
- **Genre:** Economic simulation/Tycoon  
- **Target:** 18-45 years, casual/intermediate players
- **Model:** Free-to-play with balanced microtransactions

## 🏗️ Architecture & Key Patterns

### Core Structure
- **Flutter UI + Flame Game**: `GameWidget` with Flutter overlays for UI (HUD, store, upgrades)
- **Tick-based Simulation**: 200ms ticks drive production independent of framerate
- **Isometric Rendering**: Grid ↔ World coordinate conversion with depth sorting by Y position
- **State Management**: Riverpod for meta-game state, Streams/ValueNotifier for Game↔UI bridge

### Critical Services Pattern
```dart
// All services subscribe to TickEngine
class ProductionService {
  void init() {
    gameRef.tickEngine.onTick.listen(_processTick);
  }
}
```

### Component Architecture
- `ConveyorComponent`: Moves items along grid directions (N/S/E/W)
- `MachineComponent`: Input/output slots, processing time, failure rates  
- `JunctionComponent`: Routes items based on priority/stock levels

## 🛠️ Development Workflow

### Essential Commands
```bash
# Setup
flutter pub get
dart run build_runner build

# Code Quality & Analysis
flutter analyze  # REQUIRED: Must pass with 0 errors before committing
flutter test --coverage  # Run tests with coverage

# Development  
flutter run --profile  # Performance testing

# Build
flutter build apk --release
flutter build ios --release
```

### Code Quality Requirements
- **Compilable Code**: The project MUST compile without errors at all times
- **Static Analysis**: Run `flutter analyze` and fix ALL errors before committing
- **Zero Tolerance**: No compilation errors are acceptable in any commit
- **Continuous Validation**: Check compilation after every significant change

### Project Structure
```
lib/
  game/core/factory_game.dart     # Main FlameGame
  game/services/                  # Production, Economy, Inventory
  game/components/                # Conveyor, Machine, Junction
  game/overlays/                  # Flutter UI overlays
  data/models/                    # Game data models
```

## 🎯 Project-Specific Conventions

### Isometric Grid System
```dart  
// Grid to World conversion (diamond shape)
world.x = (grid.x - grid.y) * tileWidth / 2;
world.y = (grid.x + grid.y) * tileHeight / 2;
```

### Tick Engine Pattern
All game logic runs on 200ms ticks, not frame updates. Use `TickEngine.onTick.listen()` for production, economy, and AI updates.

### Balance Configuration  
Game balance via JSON files in `assets/data/`:
- `machines.json`: Processing times, failure rates, costs
- `recipes.json`: Input/output recipes
- `prices.json`: Item values and costs

### Save System
Hive-based local persistence. Models use `copyWith` pattern for immutability.

## 🔗 Integration Points

### Flutter ↔ Flame Bridge
```dart
// Services expose ValueNotifiers for UI
class EconomyService {
  final ValueNotifier<int> money = ValueNotifier(1000);
}

// UI listens via Riverpod  
final moneyProvider = Provider((ref) => 
  ref.watch(gameServiceProvider).economyService.money);
```

### External Services
- **Firebase**: GA4 analytics + Remote Config for balance tuning
- **Ads**: Rewarded ads grant temporary production boosts
- **IAP**: Simple consumable coin packs (no server validation in MVP)

## 📋 Task Execution Guide

### Sequential Task Pattern
Execute tasks in `.github/instructions/` folder (0001-0024) in order:
1. **0001-0002**: Project vision and architecture setup
2. **0003-0005**: Dependencies, game loop, isometric rendering  
3. **0006-0010**: Map loading, components, production system, save/load
4. **0011-0015**: UI overlays, IAP, ads, analytics, tutorial
5. **0016-0024**: Localization, audio, performance, testing, deployment

### Task Dependencies
Each task builds on previous foundations. Always check completion criteria before proceeding.

## ⚡ Performance Requirements
- **Target**: 60 FPS on mid-range Android with 50+ conveyors + 10+ machines
- **Profile**: Use `flutter run --profile` and DevTools  
- **Optimization**: Sprite batching, limit draw calls, cache pathfinding

## 🎮 Core Game Loop
1. **Build**: Place conveyors, machines, junctions on isometric grid
2. **Produce**: Items flow through production lines every 200ms tick
3. **Sell**: Completed items generate revenue automatically
4. **Expand**: Reinvest profits in upgrades and new production lines  

---

## 📋 Game Design Reference

### Core Mechanics (from original GDD)
- **Production**: Choose products (toys, clothes, electronics)
- **Employees**: Hire, train, manage morale (FSM + pathfinding)  
- **Logistics**: Transport via trucks/trains/ships (speed vs cost)
- **Market Dynamics**: Product popularity cycles, random events
- **Financial Management**: Fixed costs, loans, profit optimization

### Progression Phases
1. **Local Workshop** → 2. **Small Factory** → 3. **Regional Network** → 4. **Multinational Empire**

### Monetization Strategy
- **Premium Currency**: Investment Credits for production boosts
- **Temporary Boosters**: +100% speed, instant transport
- **Cosmetics**: Factory skins, uniforms, vehicles
- **VIP Pass**: Market reports, daily bonuses

### UI Flow Requirements
- **Main Menu**: Production, Employees, Logistics, Market, Finance, Settings
- **HUD**: Money, inventory, throughput, pause button
- **Store**: Catalog with cost preview (green/red placement validation)
- **Upgrades**: Speed/quality/energy improvements with immediate effect

### Visual Style
- **Art**: Simplified cartoon style (mobile-optimized)
- **Feedback**: Animated machinery, walking workers, vehicle movement
- **UI**: Minimalist dashboards with clear information hierarchy

### Audio Requirements  
- **Music**: Calm, repetitive background for long sessions
- **SFX**: Machine sounds, trucks, celebration on large sales
- **Controls**: Independent volumes, global mute in HUD

### Performance Targets
- **FPS**: >50 on mid-range Android with 50+ conveyors + 10+ machines
- **Size**: ≤70 MB build target
- **Stability**: >99% crash-free rate

### Analytics Events (GA4)
- `tutorial_start`, `tutorial_complete`
- `first_production`, `first_sale`  
- `ad_reward_granted`, `iap_purchase_success`

---

## 🚀 Getting Started for AI Agents

**For executing all tasks sequentially:**
1. Read tasks 0001-0024 in `.github/instructions/` folder
2. Start with **0001** (project vision) → **0002** (architecture)
3. Follow dependency chain as specified in each task
4. Validate acceptance criteria before proceeding to next task
5. Each task builds incrementally toward MVP completion

**Priority order for immediate productivity:**
- 0001-0005: Foundation (vision, structure, dependencies, game loop, rendering)
- 0007-0008: Core gameplay (components, production system)
- 0011: UI integration (overlays)
- 0010: Save/load system

**Key files to understand the codebase:**
- `.github/instructions/0001-visao-escopo-mvp.md`: Complete project scope
- `.github/instructions/0002-arquitetura-estrutura-de-pastas.md`: Architecture patterns
- Individual task files contain specific implementation requirements

**Note**: All tasks contain prescriptive language for AI execution with clear acceptance criteria and deliverables.

## 3. Mecânicas Principais
- **Construção e Upgrades:**  
  - Montar linhas de produção.  
  - Atualizar máquinas para reduzir defeitos e aumentar velocidade.  

- **Funcionários:**  
  - Contratação automática/manual.  
  - Treinamento para reduzir erros.  
  - Moral (se baixa = greves ou produtividade menor).  

- **Logística:**  
  - Caminhões, trens ou navios.  
  - Escolher entre velocidade x custo.  

- **Mercado e Demanda:**  
  - Produtos têm ciclos de popularidade.  
  - Eventos aleatórios (ex: crise de chips → mais demanda de roupas).  

- **Gestão Financeira:**  
  - Custos fixos (salários, manutenção).  
  - Lucro líquido.  
  - Opção de empréstimos (com juros).  

---

## 4. Progressão
- **Fases de Expansão:**  
  1. Oficina local.  
  2. Pequena fábrica.  
  3. Rede de fábricas regionais.  
  4. Império multinacional.  

- **Tecnologias desbloqueáveis:**  
  - Automação.  
  - Robôs de produção.  
  - Energia renovável (reduz custos de operação).  

- **Mercados:**  
  - Local → Regional → Internacional.  

---

## 5. Monetização
- **Moeda Premium:** Créditos de Investimento.  
  - Comprar boosts de produção.  
  - Expandir fábrica sem esperar tempo real.  

- **Boosters Temporários:**  
  - +100% velocidade por 2h.  
  - Transporte instantâneo.  

- **Cosméticos:**  
  - Skins de fábricas, uniformes, veículos.  

- **VIP Pass Mensal:**  
  - Relatórios de mercado antecipados.  
  - 1 produção grátis instantânea por dia.  
  - Recompensas diárias melhores.  

---

## 6. Eventos e Competição
- **Eventos Semanais:**  
  - “Semana da Tecnologia Verde”: bônus em fábricas sustentáveis.  
  - “Crise de Energia”: custos de eletricidade sobem.  

- **Ranking Online:**  
  - Jogadores competem por maior faturamento semanal.  
  - Recompensas de moedas premium/cosméticos.  

---

## 7. Estilo Visual
- **Arte:** Estilo cartoon simplificado (leve para mobile, mas agradável).  
- **UI:** Minimalista, com dashboards claros.  
- **Feedback Visual:**  
  - Maquinário animado.  
  - Funcionários andando pela fábrica.  
  - Caminhões entrando/saindo.  

---

## 8. Fluxo de Telas
- **Tela Inicial:** Logo, botões de Login/Convidado.  
- **Menu Principal:** Botões para Produção, Funcionários, Logística, Mercado, Finanças, Configurações.  
- **Tela de Produção:** Escolha de produtos, upgrades de linhas de montagem.  
- **Tela de Funcionários:** Lista de contratados, status, moral, opções de treinamento.  
- **Tela de Logística:** Seleção de transportes, rotas, custos.  
- **Tela de Mercado:** Demanda atual, previsão de tendências, eventos.  
- **Tela de Finanças:** Relatórios de lucro, custos, fluxo de caixa.  
- **Loja:** Boosters, moeda premium, cosméticos.  
- **Ranking:** Placares online semanais.  

---

## 9. Diferenciais
- **Complexidade modular:** casual ou hardcore.  
- **Eventos dinâmicos:** crises, modas de consumo.  
- **Competição online:** rankings globais e regionais.  
- **Expansões temáticas:** setores como automóveis, alimentos, tecnologia verde.  

---

## 10. Som e Música
- **Trilha sonora:** Música calma e repetitiva para sessões longas.  
- **Efeitos sonoros:** Máquinas, caminhões, aplausos ao concluir vendas grandes.  

---

## 11. Narrativa (opcional)
- Jogador começa como empreendedor local, herdando uma pequena oficina.  
- Objetivo: construir um império global e se tornar referência industrial.  

### 12. Considerações Gerais
- **Performance:** Otimização para dispositivos de baixa/média performance.  
- **Acessibilidade:** Opções de texto grande, modos de cor para daltônicos.  
- **Atualizações:** Conteúdo novo trimestral (novos produtos, eventos, cosméticos).
- todas as instrucoes estao localizadas em .github/instructions acesse a pasta e execute as instrucoes de 1 a 24