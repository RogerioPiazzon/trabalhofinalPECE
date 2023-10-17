CREATE TABLE [dbo].[DimAccount](
	[AccountKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ParentAccountKey] INTEGER NULL,
	[AccountCodeAlternateKey] INTEGER NULL,
	[ParentAccountCodeAlternateKey] INTEGER NULL,
	[AccountDescription] TEXT NULL,
	[AccountType] TEXT NULL,
	[Operator] TEXT NULL,
	[CustomMembers] TEXT NULL,
	[ValueType] TEXT NULL,
	[CustomMemberOptions] TEXT NULL,
	FOREIGN KEY(ParentAccountKey)  REFERENCES DimAccount(AccountKey)
);

CREATE TABLE [dbo].[DimCurrency](
	[CurrencyKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[CurrencyAlternateKey] TEXT NOT NULL,
	[CurrencyName] TEXT NOT NULL
);

CREATE TABLE [dbo].[DimCustomer](
	[CustomerKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[GeographyKey] INTEGER NULL,
	[CustomerAlternateKey] TEXT NOT NULL,
	[Title] TEXT NULL,
	[FirstName] TEXT NULL,
	[MiddleName] TEXT NULL,
	[LastName] TEXT NULL,
	[NameStyle] NUMERIC NULL,
	[BirthDate] TEXT NULL,
	[MaritalStatus] TEXT NULL,
	[Suffix] TEXT NULL,
	[Gender] TEXT NULL,
	[EmailAddress] TEXT NULL,
	[YearlyIncome] REAL NULL,
	[TotalChildren] INTEGER NULL,
	[NumberChildrenAtHome] INTEGER NULL,
	[EnglishEducation] TEXT NULL,
	[SpanishEducation] TEXT NULL,
	[FrenchEducation] TEXT NULL,
	[EnglishOccupation] TEXT NULL,
	[SpanishOccupation] TEXT NULL,
	[FrenchOccupation] TEXT NULL,
	[HouseOwnerFlag] TEXT NULL,
	[NumberCarsOwned] INTEGER NULL,
	[AddressLine1] TEXT NULL,
	[AddressLine2] TEXT NULL,
	[Phone] TEXT NULL,
	[DateFirstPurchase] TEXT NULL,
	[CommuteDistance] TEXT NULL,
	FOREIGN KEY(GeographyKey)  REFERENCES DimGeography(GeographyKey)
);

CREATE TABLE [dbo].[DimDate](
	[DateKey] INTEGER NOT NULL,
	[FullDateAlternateKey] TEXT NOT NULL,
	[DayNumberOfWeek] INTEGER NOT NULL,
	[EnglishDayNameOfWeek] TEXT NOT NULL,
	[SpanishDayNameOfWeek] TEXT NOT NULL,
	[FrenchDayNameOfWeek] TEXT NOT NULL,
	[DayNumberOfMonth] INTEGER NOT NULL,
	[DayNumberOfYear] INTEGER NOT NULL,
	[WeekNumberOfYear] INTEGER NOT NULL,
	[EnglishMonthName] TEXT NOT NULL,
	[SpanishMonthName] TEXT NOT NULL,
	[FrenchMonthName] TEXT NOT NULL,
	[MonthNumberOfYear] INTEGER NOT NULL,
	[CalendarQuarter] INTEGER NOT NULL,
	[CalendarYear] INTEGER NOT NULL,
	[CalendarSemester] INTEGER NOT NULL,
	[FiscalQuarter] INTEGER NOT NULL,
	[FiscalYear] INTEGER NOT NULL,
	[FiscalSemester] INTEGER NOT NULL
);

CREATE TABLE [dbo].[DimDepartmentGroup](
	[DepartmentGroupKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ParentDepartmentGroupKey] INTEGER NULL,
	[DepartmentGroupName] TEXT NULL,
	FOREIGN KEY(ParentDepartmentGroupKey)  REFERENCES DimDepartmentGroup(DepartmentGroupKey)
);

CREATE TABLE [dbo].[DimEmployee](
	[EmployeeKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ParentEmployeeKey] INTEGER NULL,
	[EmployeeNationalIDAlternateKey] TEXT NULL,
	[ParentEmployeeNationalIDAlternateKey] TEXT NULL,
	[SalesTerritoryKey] INTEGER NULL,
	[FirstName] TEXT NOT NULL,
	[LastName] TEXT NOT NULL,
	[MiddleName] TEXT NULL,
	[NameStyle] NUMERIC NOT NULL,
	[Title] TEXT NULL,
	[HireDate] TEXT NULL,
	[BirthDate] TEXT NULL,
	[LoginID] TEXT NULL,
	[EmailAddress] TEXT NULL,
	[Phone] TEXT NULL,
	[MaritalStatus] TEXT NULL,
	[EmergencyContactName] TEXT NULL,
	[EmergencyContactPhone] TEXT NULL,
	[SalariedFlag] NUMERIC NULL,
	[Gender] TEXT NULL,
	[PayFrequency] INTEGER NULL,
	[BaseRate] REAL NULL,
	[VacationHours] INTEGER NULL,
	[SickLeaveHours] INTEGER NULL,
	[CurrentFlag] NUMERIC NOT NULL,
	[SalesPersonFlag] NUMERIC NOT NULL,
	[DepartmentName] TEXT NULL,
	[StartDate] TEXT NULL,
	[EndDate] TEXT NULL,
	[Status] TEXT NULL,
	[EmployeePhoto] NUMERIC NULL,
	FOREIGN KEY(ParentEmployeeKey)  REFERENCES DimEmployee(EmployeeKey),
	FOREIGN KEY(SalesTerritoryKey)  REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

CREATE TABLE [dbo].[DimGeography](
	[GeographyKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[City] TEXT NULL,
	[StateProvinceCode] TEXT NULL,
	[StateProvinceName] TEXT NULL,
	[CountryRegionCode] TEXT NULL,
	[EnglishCountryRegionName] TEXT NULL,
	[SpanishCountryRegionName] TEXT NULL,
	[FrenchCountryRegionName] TEXT NULL,
	[PostalCode] TEXT NULL,
	[SalesTerritoryKey] INTEGER NULL,
	[IpAddressLocator] TEXT NULL,
	FOREIGN KEY(SalesTerritoryKey)  REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

CREATE TABLE [dbo].[DimOrganization](
	[OrganizationKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ParentOrganizationKey] INTEGER NULL,
	[PercentageOfOwnership] TEXT NULL,
	[OrganizationName] TEXT NULL,
	[CurrencyKey] INTEGER NULL,
	FOREIGN KEY(ParentOrganizationKey)  REFERENCES DimOrganization(OrganizationKey),
	FOREIGN KEY(CurrencyKey)  REFERENCES DimCurrency(CurrencyKey)
);

CREATE TABLE [dbo].[DimProduct](
	[ProductKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ProductAlternateKey] TEXT NULL,
	[ProductSubcategoryKey] INTEGER NULL,
	[WeightUnitMeasureCode] TEXT NULL,
	[SizeUnitMeasureCode] TEXT NULL,
	[EnglishProductName] TEXT NOT NULL,
	[SpanishProductName] TEXT NOT NULL,
	[FrenchProductName] TEXT NOT NULL,
	[StandardCost] REAL NULL,
	[FinishedGoodsFlag] NUMERIC NOT NULL,
	[Color] TEXT NOT NULL,
	[SafetyStockLevel] INTEGER NULL,
	[ReorderPoint] INTEGER NULL,
	[ListPrice] REAL NULL,
	[Size] TEXT NULL,
	[SizeRange] TEXT NULL,
	[Weight] REAL NULL,
	[DaysToManufacture] INTEGER NULL,
	[ProductLine] TEXT NULL,
	[DealerPrice] REAL NULL,
	[Class] TEXT NULL,
	[Style] TEXT NULL,
	[ModelName] TEXT NULL,
	[LargePhoto] NUMERIC NULL,
	[EnglishDescription] TEXT NULL,
	[FrenchDescription] TEXT NULL,
	[ChineseDescription] TEXT NULL,
	[ArabicDescription] TEXT NULL,
	[HebrewDescription] TEXT NULL,
	[ThaiDescription] TEXT NULL,
	[GermanDescription] TEXT NULL,
	[JapaneseDescription] TEXT NULL,
	[TurkishDescription] TEXT NULL,
	[StartDate] TEXT NULL,
	[EndDate] TEXT NULL,
	[Status] TEXT NULL,
	FOREIGN KEY(ProductSubcategoryKey)  REFERENCES DimProductSubcategory(ProductSubcategoryKey)
);

CREATE TABLE [dbo].[DimProductCategory](
	[ProductCategoryKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ProductCategoryAlternateKey] INTEGER NULL,
	[EnglishProductCategoryName] TEXT NOT NULL,
	[SpanishProductCategoryName] TEXT NOT NULL,
	[FrenchProductCategoryName] TEXT NOT NULL
	
);

CREATE TABLE [dbo].[DimProductSubcategory](
	[ProductSubcategoryKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ProductSubcategoryAlternateKey] INTEGER NULL,
	[EnglishProductSubcategoryName] TEXT NOT NULL,
	[SpanishProductSubcategoryName] TEXT NOT NULL,
	[FrenchProductSubcategoryName] TEXT NOT NULL,
	[ProductCategoryKey] INTEGER NULL,
	FOREIGN KEY(ProductCategoryKey)  REFERENCES DimProductCategory(ProductCategoryKey)
);

CREATE TABLE [dbo].[DimPromotion](
	[PromotionKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[PromotionAlternateKey] INTEGER NULL,
	[EnglishPromotionName] TEXT NULL,
	[SpanishPromotionName] TEXT NULL,
	[FrenchPromotionName] TEXT NULL,
	[DiscountPct] REAL NULL,
	[EnglishPromotionType] TEXT NULL,
	[SpanishPromotionType] TEXT NULL,
	[FrenchPromotionType] TEXT NULL,
	[EnglishPromotionCategory] TEXT NULL,
	[SpanishPromotionCategory] TEXT NULL,
	[FrenchPromotionCategory] TEXT NULL,
	[StartDate] TEXT NOT NULL,
	[EndDate] TEXT NULL,
	[MinQty] INTEGER NULL,
	[MaxQty] INTEGER NULL
);

CREATE TABLE [dbo].[DimReseller](
	[ResellerKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[GeographyKey] INTEGER NULL,
	[ResellerAlternateKey] TEXT NULL,
	[Phone] TEXT NULL,
	[BusinessType] TEXT NOT NULL,
	[ResellerName] TEXT NOT NULL,
	[NumberEmployees] INTEGER NULL,
	[OrderFrequency] TEXT NULL,
	[OrderMonth] INTEGER NULL,
	[FirstOrderYear] INTEGER NULL,
	[LastOrderYear] INTEGER NULL,
	[ProductLine] TEXT NULL,
	[AddressLine1] TEXT NULL,
	[AddressLine2] TEXT NULL,
	[AnnualSales] REAL NULL,
	[BankName] TEXT NULL,
	[MinPaymentType] INTEGER NULL,
	[MinPaymentAmount] REAL NULL,
	[AnnualRevenue] REAL NULL,
	[YearOpened] INTEGER NULL,
	FOREIGN KEY(GeographyKey)  REFERENCES DimGeography(GeographyKey)

);

CREATE TABLE [dbo].[DimSalesReason](
	[SalesReasonKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[SalesReasonAlternateKey] INTEGER NOT NULL,
	[SalesReasonName] TEXT NOT NULL,
	[SalesReasonReasonType] TEXT NOT NULL
);

CREATE TABLE [dbo].[DimSalesTerritory](
	[SalesTerritoryKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[SalesTerritoryAlternateKey] INTEGER NULL,
	[SalesTerritoryRegion] TEXT NOT NULL,
	[SalesTerritoryCountry] TEXT NOT NULL,
	[SalesTerritoryGroup] TEXT NULL,
	[SalesTerritoryImage] NUMERIC NULL
);

CREATE TABLE [dbo].[DimScenario](
	[ScenarioKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ScenarioName] TEXT NULL
);

CREATE TABLE [dbo].[FactAdditionalInternationalProductDescription](
	[ProductKey] INTEGER NOT NULL,
	[CultureName] TEXT NOT NULL,
	[ProductDescription] TEXT NOT NULL
);

CREATE TABLE [dbo].[FactCallCenter](
	[FactCallCenterID] INTEGER PRIMARY KEY AUTOINCREMENT,
	[DateKey] INTEGER NOT NULL,
	[WageType] TEXT NOT NULL,
	[Shift] TEXT NOT NULL,
	[LevelOneOperators] INTEGER NOT NULL,
	[LevelTwoOperators] INTEGER NOT NULL,
	[TotalOperators] INTEGER NOT NULL,
	[Calls] INTEGER NOT NULL,
	[AutomaticResponses] INTEGER NOT NULL,
	[Orders] INTEGER NOT NULL,
	[IssuesRaised] INTEGER NOT NULL,
	[AverageTimePerIssue] INTEGER NOT NULL,
	[ServiceGrade] REAL NOT NULL,
	[Date] TEXT NULL,
	FOREIGN KEY(DateKey)  REFERENCES DimDate(DateKey)
);

CREATE TABLE [dbo].[FactCurrencyRate](
	[CurrencyKey] INTEGER NOT NULL,
	[DateKey] INTEGER NOT NULL,
	[AverageRate] REAL NOT NULL,
	[EndOfDayRate] REAL NOT NULL,
	[Date] TEXT NULL,
	FOREIGN KEY(DateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(CurrencyKey)  REFERENCES DimCurrency(CurrencyKey)
);

CREATE TABLE [dbo].[FactFinance](
	[FinanceKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[DateKey] INTEGER NOT NULL,
	[OrganizationKey] INTEGER NOT NULL,
	[DepartmentGroupKey] INTEGER NOT NULL,
	[ScenarioKey] INTEGER NOT NULL,
	[AccountKey] INTEGER NOT NULL,
	[Amount] REAL NOT NULL,
	[Date] TEXT NULL,
	FOREIGN KEY(DateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(OrganizationKey)  REFERENCES DimOrganization(OrganizationKey),
	FOREIGN KEY(DepartmentGroupKey)  REFERENCES DimDepartmentGroup(DepartmentGroupKey),
	FOREIGN KEY(ScenarioKey)  REFERENCES DimScenario(ScenarioKey),
	FOREIGN KEY(AccountKey)  REFERENCES DimAccount(AccountKey)
);

CREATE TABLE [dbo].[FactInternetSales](
	[ProductKey] INTEGER NOT NULL,
	[OrderDateKey] INTEGER NOT NULL,
	[DueDateKey] INTEGER NOT NULL,
	[ShipDateKey] INTEGER NOT NULL,
	[CustomerKey] INTEGER NOT NULL,
	[PromotionKey] INTEGER NOT NULL,
	[CurrencyKey] INTEGER NOT NULL,
	[SalesTerritoryKey] INTEGER NOT NULL,
	[SalesOrderNumber] TEXT NOT NULL,
	[SalesOrderLineNumber] INTEGER NOT NULL,
	[RevisionNumber] INTEGER NOT NULL,
	[OrderQuantity] INTEGER NOT NULL,
	[UnitPrice] REAL NOT NULL,
	[ExtendedAmount] REAL NOT NULL,
	[UnitPriceDiscountPct] REAL NOT NULL,
	[DiscountAmount] REAL NOT NULL,
	[ProductStandardCost] REAL NOT NULL,
	[TotalProductCost] REAL NOT NULL,
	[SalesAmount] REAL NOT NULL,
	[TaxAmt] REAL NOT NULL,
	[Freight] REAL NOT NULL,
	[CarrierTrackingNumber] TEXT NULL,
	[CustomerPONumber] TEXT NULL,
	[OrderDate] TEXT NULL,
	[DueDate] TEXT NULL,
	[ShipDate] TEXT NULL,
	FOREIGN KEY(ProductKey)  REFERENCES DimProduct(ProductKey),
	FOREIGN KEY(OrderDateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(DueDateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(ShipDateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(CustomerKey)  REFERENCES DimCustomer(CustomerKey),
	FOREIGN KEY(PromotionKey)  REFERENCES DimPromotion(PromotionKey),
	FOREIGN KEY(CurrencyKey)  REFERENCES DimCurrency(CurrencyKey),
	FOREIGN KEY(SalesTerritoryKey)  REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

CREATE TABLE [dbo].[FactInternetSalesReason](
	[SalesOrderNumber] TEXT NOT NULL,
	[SalesOrderLineNumber] INTEGER NOT NULL,
	[SalesReasonKey] INTEGER NOT NULL,
	FOREIGN KEY(SalesOrderNumber,SalesOrderLineNumber)  REFERENCES FactInternetSales(SalesOrderNumber,SalesOrderLineNumber),
	FOREIGN KEY(SalesReasonKey)  REFERENCES DimSalesReason(SalesReasonKey)
);

CREATE TABLE [dbo].[FactProductInventory](
	[ProductKey] INTEGER NOT NULL,
	[DateKey] INTEGER NOT NULL,
	[MovementDate] TEXT NOT NULL,
	[UnitCost] REAL NOT NULL,
	[UnitsIn] INTEGER NOT NULL,
	[UnitsOut] INTEGER NOT NULL,
	[UnitsBalance] INTEGER NOT NULL,
	FOREIGN KEY(ProductKey)  REFERENCES DimProduct(ProductKey),
	FOREIGN KEY(DateKey)  REFERENCES DimDate(DateKey)
);

CREATE TABLE [dbo].[FactResellerSales](
	[ProductKey] INTEGER NOT NULL,
	[OrderDateKey] INTEGER NOT NULL,
	[DueDateKey] INTEGER NOT NULL,
	[ShipDateKey] INTEGER NOT NULL,
	[ResellerKey] INTEGER NOT NULL,
	[EmployeeKey] INTEGER NOT NULL,
	[PromotionKey] INTEGER NOT NULL,
	[CurrencyKey] INTEGER NOT NULL,
	[SalesTerritoryKey] INTEGER NOT NULL,
	[SalesOrderNumber] TEXT NOT NULL,
	[SalesOrderLineNumber] INTEGER NOT NULL,
	[RevisionNumber] INTEGER NULL,
	[OrderQuantity] INTEGER NULL,
	[UnitPrice] REAL NULL,
	[ExtendedAmount] REAL NULL,
	[UnitPriceDiscountPct] REAL NULL,
	[DiscountAmount] REAL NULL,
	[ProductStandardCost] REAL NULL,
	[TotalProductCost] REAL NULL,
	[SalesAmount] REAL NULL,
	[TaxAmt] REAL NULL,
	[Freight] REAL NULL,
	[CarrierTrackingNumber] TEXT NULL,
	[CustomerPONumber] TEXT NULL,
	[OrderDate] TEXT NULL,
	[DueDate] TEXT NULL,
	[ShipDate] TEXT NULL,
	FOREIGN KEY(ProductKey)  REFERENCES DimProduct(ProductKey),
	FOREIGN KEY(OrderDateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(DueDateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(ShipDateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(ResellerKey)  REFERENCES DimReseller(ResellerKey),
	FOREIGN KEY(EmployeeKey)  REFERENCES DimEmployee(EmployeeKey),
	FOREIGN KEY(PromotionKey)  REFERENCES DimPromotion(PromotionKey),
	FOREIGN KEY(CurrencyKey)  REFERENCES DimCurrency(CurrencyKey),
	FOREIGN KEY(SalesTerritoryKey)  REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

CREATE TABLE [dbo].[FactSalesQuota](
	[SalesQuotaKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[EmployeeKey] INTEGER NOT NULL,
	[DateKey] INTEGER NOT NULL,
	[CalendarYear] INTEGER NOT NULL,
	[CalendarQuarter] INTEGER NOT NULL,
	[SalesAmountQuota] REAL NOT NULL,
	[Date] TEXT NULL,
	FOREIGN KEY(EmployeeKey)  REFERENCES DimEmployee(EmployeeKey),
	FOREIGN KEY(DateKey)  REFERENCES DimDate(DateKey)
);

CREATE TABLE [dbo].[FactSurveyResponse](
	[SurveyResponseKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[DateKey] INTEGER NOT NULL,
	[CustomerKey] INTEGER NOT NULL,
	[ProductCategoryKey] INTEGER NOT NULL,
	[EnglishProductCategoryName] TEXT NOT NULL,
	[ProductSubcategoryKey] INTEGER NOT NULL,
	[EnglishProductSubcategoryName] TEXT NOT NULL,
	[Date] TEXT NULL,
	FOREIGN KEY(DateKey)  REFERENCES DimDate(DateKey),
	FOREIGN KEY(CustomerKey)  REFERENCES DimCustomer(CustomerKey)

);

CREATE TABLE [dbo].[NewFactCurrencyRate](
	[AverageRate] REAL NULL,
	[CurrencyID] TEXT NULL,
	[CurrencyDate] TEXT NULL,
	[EndOfDayRate] REAL NULL,
	[CurrencyKey] INTEGER NULL,
	[DateKey] INTEGER NULL
);

CREATE TABLE [dbo].[ProspectiveBuyer](
	[ProspectiveBuyerKey] INTEGER PRIMARY KEY AUTOINCREMENT,
	[ProspectAlternateKey] TEXT NULL,
	[FirstName] TEXT NULL,
	[MiddleName] TEXT NULL,
	[LastName] TEXT NULL,
	[BirthDate] TEXT NULL,
	[MaritalStatus] TEXT NULL,
	[Gender] TEXT NULL,
	[EmailAddress] TEXT NULL,
	[YearlyIncome] REAL NULL,
	[TotalChildren] INTEGER NULL,
	[NumberChildrenAtHome] INTEGER NULL,
	[Education] TEXT NULL,
	[Occupation] TEXT NULL,
	[HouseOwnerFlag] TEXT NULL,
	[NumberCarsOwned] INTEGER NULL,
	[AddressLine1] TEXT NULL,
	[AddressLine2] TEXT NULL,
	[City] TEXT NULL,
	[StateProvinceCode] TEXT NULL,
	[PostalCode] TEXT NULL,
	[Phone] TEXT NULL,
	[Salutation] TEXT NULL,
	[Unknown] INTEGER NULL
);



