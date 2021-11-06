Create Database PortfolioProject
Select *
From dbo.CovidDeaths
Where continent is not NULL
Order by 3,4

--Select *
--From dbo.CovidVaccinations
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From dbo.covidDeaths
Where continent is not NULL
Order by 1,2

--Deathpercentage of United States

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From dbo.covidDeaths
Where location like '%states%'
AND continent is not NULL
Order by 1,2

--Percentage of population got covid in United States

Select Location, date, Population,total_cases,  (total_cases/Population)*100 As PercentagePopulationInfected
From dbo.covidDeaths
--Where location like '%states%'
--AND continent is not NULL
Order by 1,2

--Countries hegiest infection rate compared to population

Select Location, Population, MAX(total_cases) As HighestInfectionCount, MAX((total_cases/Population))*100 As PercentagePopulationInfected
From dbo.covidDeaths
Where continent is not NULL
Group by Location, Population
Order by PercentagePopulationInfected DESC

--Heighest Death count per Location

Select Location, MAX(Cast(Total_deaths As INT)) As TotalDeathCount
From dbo.CovidDeaths
Where continent is not NULL
Group by Location
Order by TotalDeathCount DESC


Heighest Death count per Continent

Select Continent, MAX(Cast(Total_deaths As INT)) As TotalDeathCount
From dbo.CovidDeaths
Where continent is not NULL
Group by Continent
Order by TotalDeathCount DESC

--Showing continent with highest death count per population

Select Continent, Population, Max(Cast(Total_deaths As INT)) As TotalDeathCount, Max(Cast(Total_deaths As INT))/Population As DeathCountPercentage
From dbo.CovidDeaths
Where continent is not NULL
Group by Continent, Population
Order by DeathCountPercentage DESC

--Global Number

Select Location, date, Population,total_deaths,  (total_deaths/Population)*100 As DeathPercentage
From dbo.covidDeaths
--Where location like '%states%'
Where continent is not NULL
Order by 1,2

--Global Number
Select Sum(new_cases) As  NewCasesSum, Sum(Cast(new_deaths As INT)) As NewDeathsSum, Sum(Cast(new_deaths As INT))/Sum(new_cases)*100 As DeathPercentage
From dbo.CovidDeaths
Where continent is not NULL
--Group by date
Order by 1,2


Select *
From CovidVaccinations


Select *
From dbo.CovidDeaths Dea
Join dbo.CovidVaccinations Vac 
ON Dea.Location = Vac.Location
AND Dea.Date = Vac.Date

--Population vs Vaccination

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
From dbo.CovidDeaths Dea
Join dbo.CovidVaccinations Vac
ON Dea.Location = Vac.Location
AND Dea.Date = Vac.Date
Where Dea.continent is not NULL
Order by 1,2,3

--Rolling People Vaccinated

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
,Sum(Cast(Vac.new_vaccinations As INT)) Over (Partition by Dea.Location order by Dea.Location, Dea.Date) As RollingPeopleVaccinated
From dbo.CovidDeaths Dea
Join dbo.CovidVaccinations Vac
ON Dea.Location = Vac.Location
AND Dea.Date = Vac.Date
Where Dea.continent is not NULL
And Dea.Location = 'India'
Order by 2,3

--Percentatege of vaccination
With POPVSVAC (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
As
(
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
,Sum(Cast(Vac.new_vaccinations As INT)) Over (Partition by Dea.Location order by Dea.Location, Dea.Date) As RollingPeopleVaccinated
From dbo.CovidDeaths Dea
Join dbo.CovidVaccinations Vac
ON Dea.Location = Vac.Location
AND Dea.Date = Vac.Date
Where Dea.continent is not NULL
And Dea.Location = 'India'
--Order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100 As VaccinationPercentage
From POPVSVAC


--TEMP Table
--Drop table VaccinationPercentage

Create Table VaccinationPercentage
(Continent nvarchar(255),
Location nvarchar(255),
Date DateTime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into VaccinationPercentage
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
,Sum(Cast(Vac.new_vaccinations As INT)) Over (Partition by Dea.Location order by Dea.Location, Dea.Date) As RollingPeopleVaccinated
From dbo.CovidDeaths Dea
Join dbo.CovidVaccinations Vac
ON Dea.Location = Vac.Location
AND Dea.Date = Vac.Date
Where Dea.continent is not NULL
And Dea.Location = 'India'
--Order by 2,3

Select*, (RollingPeopleVaccinated/Population)*100 As VaccinationPercentage
From VaccinationPercentage


--Creating view

Create view VaccinationPercentage1 As
Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
,Sum(Cast(Vac.new_vaccinations As INT)) Over (Partition by Dea.Location order by Dea.Location, Dea.Date) As RollingPeopleVaccinated
From dbo.CovidDeaths Dea
Join dbo.CovidVaccinations Vac
ON Dea.Location = Vac.Location
AND Dea.Date = Vac.Date
Where Dea.continent is not NULL
And Dea.Location = 'India'
--Order by 2,3

Select *
From VaccinationPercentage1

