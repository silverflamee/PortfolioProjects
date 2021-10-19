select * from [Portfolio Project Covid]..[covid-deaths]
where continent is not null
order by 3,4

--select * from [Portfolio Project Covid]..[covid-vaccinations]
--order by 3,4

select *from [covid-deaths];

select location, date, total_cases, new_cases, total_deaths, population   from [Portfolio Project Covid]..[covid-deaths]
where continent is not null
order by 1,2


--Total Cases VS Total Deaths
--Shows the Death Ratio
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 Death_Percentage   from [Portfolio Project Covid]..[covid-deaths]
where continent is not null
order by 1,2

--Total Cases VS Population
--Shows percentage of population who got Covid
select location, date, population, total_cases, (total_cases/population)*100 Infection_Percentage   from [Portfolio Project Covid]..[covid-deaths]
where location=	'India' and continent is not null
order by 1,2

--Looking at countries with highest Infection rate as compared to population

select location,population, max(total_cases) Total_infection_Count, max((total_cases/population))*100 Percentage_Population_Infected   from [Portfolio Project Covid]..[covid-deaths]
where continent is not null
group by location, population
order by Percentage_Population_Infected desc;

--Shoowing countries with highest death count per population

select location, max(cast(total_deaths as int)) Total_Death_Count, max((cast(total_deaths as int)/population))*100 Percentage_Population_Died   from [Portfolio Project Covid]..[covid-deaths]
where continent is not null
group by location
order by Total_Death_Count desc;

--Shoowing Continents with highest death count per population

select continent, max(cast(total_deaths as int)) Total_Death_Count   from [Portfolio Project Covid]..[covid-deaths]
where continent is not null
group by continent
order by Total_Death_Count desc;

--Showing Cases and Deaths Globally

select date, sum(new_cases) Total_cases, sum(cast(new_deaths as int)) Total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 Death_Percentage   from [Portfolio Project Covid]..[covid-deaths]
where continent is not null
group by date
order by 1,2

--Joins

--Showing Total population & New Vaccinations per day

--Using CTE

with popvac (continent,location,date,population,new_vaccinations,sum_of_new_vaccinations)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) sum_of_new_vaccinations
from [Portfolio Project Covid]..[covid-deaths] dea join [Portfolio Project Covid]..[covid-vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2
)

select *, (sum_of_new_vaccinations/population)*100 Percentage_people_vaccinated
from popvac

--TEMP Table
Drop Table #PercentagePeopleVaccinated
create table #PercentagePeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations  numeric,
Sum_of_new_Vaccinations numeric
)


insert into #PercentagePeopleVaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) sum_of_new_vaccinations
from [Portfolio Project Covid]..[covid-deaths] dea join [Portfolio Project Covid]..[covid-vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2

select *, (sum_of_new_vaccinations/population)*100 Percentage_people_vaccinated
from #PercentagePeopleVaccinated

--Creating Views
Go
Create View PercentPeopleVaccinated as

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) sum_of_new_vaccinations
from [Portfolio Project Covid]..[covid-deaths] dea join [Portfolio Project Covid]..[covid-vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
Go
select *from 
PercentPeopleVaccinated

