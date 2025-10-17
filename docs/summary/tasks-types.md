## 2.6. Получить список возможных типов Заданий

**Назначение:** для использования в запросах создания Заданий

**Запрос:** `/api/v2/tasks/types`

**Тип запроса:** GET

**Ответ:**

```json
{
  "meta": {}
  "response": {
    "types": [
      {
        "name": "SummarySynop",
        "caption": "КН-01 (SYNOP)"
      }, 
      {
        "name": "SummarySea",
        "caption": "КН-02 (SEA)"
      }, 
      {
        "name": "SummaryRHOB",
        "caption": "КН-13 (РХОБ)"
      }, 
      {
        "name": "SummaryHydra",
        "caption": "КН-15 (ВОДА)"
      }
    ]
  }
}
```
