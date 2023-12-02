
-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2

-- data % of total cases and population
	select Location, total_cases, new_cases, total_deaths, population, ((total_cases/population)*100) as Casespercentage
	From CovidDeaths
	Where continent is not null 
	order by 1,2


	-- data % of total deaths and population
	select Location, total_cases, new_cases, total_deaths, population, ((total_deaths/population)*100) as deathspercentageperpopulation
	From CovidDeaths
	Where continent is not null 
	order by 1,2

	
	-- data % of total deaths and total cases
	select Location, total_cases, new_cases, total_deaths, population, (((cast(total_deaths as int))/total_cases)*100) as deathspercentage
	From CovidDeaths
	Where continent is not null 
	order by 1,2

	-- countries with highest infection rate per population

	select location, population, max(total_cases) as highesttotalcases, max((total_cases/population)*100) as Casespercentage
	from COVIDDEATHS
	Where continent is not null
group by location, population
 

order by Casespercentage desc

-- countries with highest death rate per popluation 

	select location, population, max(total_deaths) as highesttotaldeaths, max((total_deaths/population)*100) as deathspercentage
	from COVIDDEATHS
	Where continent is not null 
group by location, population
order by deathspercentage desc

--continent with highest death count 
select continent, max(cast(total_deaths as int)) as totaldeath 
from COVIDDEATHS
where continent is not null 
group by continent 
order by totaldeath desc


-- continents with highest death rate per population
select a.continent, a.population, a.highesttotaldeaths, (a.highesttotaldeaths/a.population)*100 as pop from
(select continent, max(population) as population , max(total_deaths) as highesttotaldeaths 
from COVIDDEATHS
where continent is not null
group by continent) a

-- global data

select date,sum(new_cases) as totalcases , sum(new_deaths) as newdeaths, sum(new_deaths)/nullif (sum(new_cases),0) *100 as deathrate
from COVIDDEATHS
where continent is not null
group by date
order by date asc



-- total vaccination vs population s

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) AS ROLLINGPEOPLEVACCINATIONS
from COVIDDEATHS dea
join COVIDVACCINATIONS vac
on dea.date=vac.date and dea.location=vac.location
WHERE dea.continent is not null
order by 2,3





-- USING CTE 
WITH CTE_POPVSVAC (CONTINENT, LOCATION, DATE, POPULATION, NEW_VACCNATIONS, ROLLINGPEOPLEVACCINATIONS) AS
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) AS ROLLINGPEOPLEVACCINATIONS
from COVIDDEATHS dea
join COVIDVACCINATIONS vac
on dea.date=vac.date and dea.location=vac.location
WHERE dea.continent is not null)


SELECT * , (ROLLINGPEOPLEVACCINATIONS/POPULATION)*100 AS PERCENTAGEVACC
FROM CTE_POPVSVAC


-- USING TEMP TABLE
CREATE TABLE #POPVSVACT
(CONTINENT NVARCHAR(255),
LOCATION NVARCHAR (255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
ROLLINGPEOPLEVACCINATIONS NUMERIC)


INSERT INTO #POPVSVACT 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) AS ROLLINGPEOPLEVACCINATIONS
from COVIDDEATHS dea
join COVIDVACCINATIONS vac
on dea.date=vac.date and dea.location=vac.location
WHERE dea.continent is not null

SELECT* ,(ROLLINGPEOPLEVACCINATIONS/POPULATION)*100 AS PERCENTAGEVACC
FROM #POPVSVACT 



