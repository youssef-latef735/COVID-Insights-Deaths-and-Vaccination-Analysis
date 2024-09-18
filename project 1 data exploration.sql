select *from covid_deaths
where continent is not null 
order by 3,4

select *from covid_vaccinations 
order by 3,4

--select data that we are going to be useing

select location,date,total_cases,new_cases,total_deaths,population
from covid_deaths
order by 1,2

--looking for total cases vs total deaths

select location,date,total_cases,total_deaths,(total_cases/total_deaths)*100 as'percentage' 
from covid_deaths

select location,date,total_cases,total_deaths,(total_cases/total_deaths)*100 as'percentage' 
from covid..covid_deaths
where location LIKE 'Af____'
order by 1,2

--looking at total cases vs populations 
--show what percentage of population got covid

select location,date,total_cases,population,(total_cases/population)*100 as 'population_percentage'
from covid_deaths
where [location]='Africa' 
order by 1,2

select [location],[population],max(total_cases) as highest ,MAX(total_cases/[population])*100 as 'population_percentage'
from covid_deaths
group by [location],[population]
order by population_percentage desc


--showing countries with highest death count per population

select [location],max(total_deaths) as total_death_count
from covid_deaths
where continent is not null 
group by location
order by total_death_count
 
 --let's breaks things down by continent

 select continent, max(population) as total_population
 from covid_deaths
 where continent is not null
 group by continent
 order by total_population desc

 --global number 

 select sum(new_cases) as total_cases ,sum(cast (new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentagea
 from covid_deaths
 --group by date 
 order by 1,2


 --looking at total population vs vaccinations

 select *
 from covid_deaths dea join covid_vaccinations vac
 on dea.location=vac.location and dea.date=vac.date

 select dea.continent,dea.location,dea.date,dea.population,vac. new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.[date]) as rolling_people_vaccinations
 from covid_deaths dea join covid_vaccinations vac
 on dea.location=vac.location and dea.date=vac.date
 where dea.continent is not null 
 order by 2,3
  
  --use cte
  with popvsvac (continent,location,date,population,new_vaccinations,rolling_people_vaccinations)
  as
  (
  select dea.continent,dea.location,dea.date,dea.population,vac. new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.[date]) as rolling_people_vaccinations
 from covid_deaths dea join covid_vaccinations vac
 on dea.location=vac.location and dea.date=vac.date
 where dea.continent is not null 
 --order by 2,3
 )
 select*,(rolling_people_vaccinations/population)*100 as 'percetage people who take a vaccina'
 from popvsvac

 --creating view to store data for later visualization

 create view percentage_population_vaccinated
 as
  select dea.continent,dea.location,dea.date,dea.population,vac. new_vaccinations,
 sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.[date]) as rolling_people_vaccinations
 from covid_deaths dea join covid_vaccinations vac
 on dea.location=vac.location and dea.date=vac.date
 where dea.continent is not null 
 --order by 2,3

 select *from percentage_population_vaccinated






















