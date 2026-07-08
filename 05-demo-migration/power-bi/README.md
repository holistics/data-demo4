# Power BI migration assets

This folder contains the Holistics AMQL migration output for the AdventureWorks Sales Power BI sample.

## Download source Power BI file

Go to the Microsoft Power BI Desktop samples repository and download the AdventureWorks Sales sample `.pbix` file:

https://github.com/microsoft/powerbi-desktop-samples/blob/main/AdventureWorks%20Sales%20Sample/AdventureWorks%20Sales.pbix

## Convert `.pbix` to Power BI Project format

1. Open `AdventureWorks Sales.pbix` in Power BI Desktop.
2. Use **File → Save As**.
3. Choose **Power BI Project (`.pbip`)** format.
4. Save the generated project under `05-demo-migration/power-bi/`.

Expected generated assets:

```text
05-demo-migration/power-bi/
├── AdventureWorksSales.Report/
└── AdventureWorksSales.SemanticModel/
```

The converted Power BI assets are source inputs for migration only. They are ignored by git and should not be committed.

## Holistics AMQL output

The migrated Holistics assets live in:

```text
05-demo-migration/power-bi/amql/
├── dashboards/
├── datasets/
├── models/
└── MIGRATION_NOTES.md
```
