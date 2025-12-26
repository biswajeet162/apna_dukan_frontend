# Apna Dukan - Flutter E-commerce App

A modern e-commerce application built with Flutter using a clean architecture approach.

## Project Structure

This project follows a feature-based architecture with clear separation of concerns:

- **core/**: App-wide shared code (constants, config, network, routes, theme, utils, widgets)
- **features/**: Feature-based modules (auth, product, cart, order, profile)
- **assets/**: Images, icons, and fonts

## Features

- User Authentication (Login/Register)
- Product Browsing
- Shopping Cart
- Order Management
- User Profile

## Getting Started

1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. (Optional) Start the mock server for testing:
   ```bash
   cd mock_server
   dart pub get
   dart run mock_server.dart
   ```
   See [SETUP_MOCK_SERVER.md](SETUP_MOCK_SERVER.md) for detailed instructions.

3. Run the app:
   ```bash
   flutter run
   ```

## Mock Server

This project includes a mock JSON server for testing without a backend. See [SETUP_MOCK_SERVER.md](SETUP_MOCK_SERVER.md) for setup and usage instructions.

## Architecture

The project uses a clean architecture pattern with:
- **Data Layer**: Models, repositories, and data sources
- **Presentation Layer**: Screens, widgets, and providers
- **Core Layer**: Shared utilities and configurations
