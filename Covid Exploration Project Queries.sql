/* Created by : Naomi
Created on: 10.10.23*/
--SELECT *
--FROM [Data Exploration Portfolio Project ]..CovidDeaths
--ORDER BY 3, 4

--SELECT *
--FROM [Data Exploration Portfolio Project ]..CovidVaccinations
--ORDER BY 3, 4

--SELECT Location, date, total_cases, new_cases, total_deaths, population
--FROM [Data Exploration Portfolio Project ]..CovidDeaths
--ORDER BY 1,2 

--Examining Total Cases vs Total deaths
--Shows the likelihood of dying if person in Finland cotracted Covid in Finland

--SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS 'Total Percentage Deaths'
--FROM [Data Exploration Portfolio Project ]..CovidDeaths
--WHERE location LIKE 'Finland'
--ORDER BY 1,2

--Examining Total Cases vs Total Population
--Shows percentage of populations that contracted covid in Finland

/*SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS 'Percentage of Population that got Covid',
ROUND(total_cases/population*100, 2) AS 'Percentage of Population that got Covid Rounded off'
FROM [Data Exploration Portfolio Project ]..CovidDeaths
--WHERE location LIKE 'Finland'
ORDER BY 1,2*/

--Examining Countries with Highest Infection Rate compared to Population

/*SELECT Location, Population, MAX(total_cases) AS 'Highest Infection Rate', ROUND(MAX((total_cases/population))*100,2) AS 'Highest Infection Rate Percentage'
--FROM [Data Exploration Portfolio Project ]..CovidDeaths
--WHERE location LIKE 'Finland'
--GROUP BY location, population
--ORDER BY [Highest Infection Rate Percentage] DESC*/

--Showing Countries with Hig´hest Death Count Per Population

/*SELECT Location, MAX(cast(total_deaths as int)) AS 'Total Death Count'
FROM [Data Exploration Portfolio Project ]..CovidDeaths
--WHERE location LIKE 'Finland'
WHERE continent is not null
GROUP BY location
ORDER BY [Total Death Count] DESC*/

--SHowing Total Death Count by Continent

/*SELECT continent, MAX(cast(total_deaths as int)) AS 'Total Death Count'
FROM [Data Exploration Portfolio Project ]..CovidDeaths
--WHERE location LIKE 'Finland'
WHERE continent is not null
GROUP BY continent
ORDER BY [Total Death Count] DESC*/

--	GLOBAL NUMBERS
--This query shows the Global cases and deaths by date during the pandemic

/*SELECT date, SUM(new_cases)AS total_cases, SUM(cast(new_deaths as int)) AS Total_deaths, ROUND(SUM(cast(new_deaths as int))/SUM(new_cases)*100,2)AS DeathPercentage

FROM [Data Exploration Portfolio Project ]..CovidDeaths

WHERE continent is not null	

Group by date

--Order by 1,2*/

--This shows the total cases and total deaths and percentage rate of death during the time in question.

/*SELECT SUM(new_cases)AS total_cases, SUM(cast(new_deaths as int)) AS Total_deaths, ROUND(SUM(cast(new_deaths as int))/SUM(new_cases)*100,2)AS DeathPercentage
FROM [Data Exploration Portfolio Project ]..CovidDeaths
WHERE continent is not null	
Order by 1,2*/

--JOINING THE TABLES
--Looking at Total Population Vs Vaccination 

SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingCountofVaccinatedPeople

FROM [Data Exploration Portfolio Project ]..CovidDeaths DEA
JOIN [Data Exploration Portfolio Project ]..CovidVaccinations VAC 
ON DEA.location=VAC.location
AND DEA.date=VAC.date
WHERE dea.continent is not null
ORDER BY 2,3

--Exploring the percentage of People Vaccinated
--USING TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingCountofVaccinatedPeople numeric
)
Insert into #PercentPopulationVaccinated

SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingCountofVaccinatedPeople
FROM [Data Exploration Portfolio Project ]..CovidDeaths DEA
JOIN [Data Exploration Portfolio Project ]..CovidVaccinations VAC 
ON DEA.location=VAC.location
AND DEA.date=VAC.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingCountofVaccinatedPeople/Population)*100
FROM #PercentPopulationVaccinated


--Creating Views to store Data for Later Visualizations

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingCountofVaccinatedPeople
FROM [Data Exploration Portfolio Project ]..CovidDeaths DEA
JOIN [Data Exploration Portfolio Project ]..CovidVaccinations VAC 
ON DEA.location=VAC.location
AND DEA.date=VAC.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated