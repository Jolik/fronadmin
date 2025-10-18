## Описание объектной модели

### Базовые классы в EntityUnit.pas

1. TFieldSet - класс инкапсулирующий набор полей и базовые методы
  * Parse - парсинг данных из JSON
  * Serialize - представление данных в виде JSON

2. TFieldSetList - массив объектов TFieldSet с и базовыми методами
  * ParseList - парсинг данных из JSON
  * AddList - доваляет данные из JSON
  * SerializeList - представление данных в виде JSON

3. TEntity (TFieldSet) - класс инкапсулирующий набор полей спреопределенными полями:
  *  Id: String;
  *  DepId: string;
  *  Name: String;
  *  CompId: string;
  *  Caption: String;
  *  Created: TDateTime;
  *  Updated: TDateTime;
  *  Enabled: boolean;
  *  Def: String;

  *  Settings: TSettings;
  *  Body: TBody;
  *  Data: TData;

  *  ListClassType: TEntityListClass;
  
  Типы полей Settings, Body и Data могут быть переопределены потомком, чтобы указать "свои" реализации этих классов

  Тип поля ListClassType может быть переопределен потомком, чтобы указать "свою" реализацию списка классов 


2. TEntityList (TFieldSetList) - массив объектов TEntity
   * ItemClassType: TEntityClass;

  Тип поля ItemClassType может быть переопределен потомком, чтобы указать "свою" реализацию элемента списка 

Таким образом, задача разработчика заключается в наследовании классов и реализации методов Parse и Serialize для конкретной сущности API

<img width="1280" height="884" alt="image" src="https://github.com/user-attachments/assets/5ad45e0b-9633-4539-9978-7f6172858f0a" />

1. Окно TAbonentsForm - окно для управления Абонентами (abonents)
2. Окно TAbonentEditForm - окно для редактирования сущности Абонент
3. Брокер TAbonentBroker - класс для реализации REST API сущности Абонент на сервере
4. Окно TSourcesForm - окно для управления Источниками (sources)
5. Окно TSourcesEditForm - окно для редактирования сущности Источник
6. Брокер TSourceBroker - класс для реализации REST API сущности Источник на сервере
7. Иконка конкретного окна
9. Класс MainModule.IdHTTP для обмена с бэкендом
   

Классы для хранения массивов строк

Варианты
      "channels": [
        "lch1",
        "mitra"
      ],
      "attr": {
        "name": "TTAAii",
        "email": "first@sample.com"
      },

        "channels": {
          "lch1": [],
          "lch2": [
            "ab1"
          ]
        },