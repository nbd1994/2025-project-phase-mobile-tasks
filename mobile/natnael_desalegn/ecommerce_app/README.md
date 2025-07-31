# ecommerce_app

A new Flutter project.

## Getting Started
Domain Layer: Contains business logic, entities (like Product), and repository interfaces (ProductMgtRepository).
Data Layer: Implements repositories, models (ProductModel), and handles data sources (like local storage).
Presentation Layer: Handles UI and user interaction.
## Example Data Flow
UI requests data (e.g., product details).
UseCase (like UpdateProduct) is called from the domain layer.
The UseCase calls the Repository Interface (ProductMgtRepository).
The Repository Implementation in the data layer fetches or updates data using models (ProductModel).
Models convert data from JSON to Dart objects and vice versa.
Results (success or failure) are returned up to the UI.
