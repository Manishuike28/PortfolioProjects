select *
From PortfolioProject..CovidDeaths
order by 3,4

Select location, date, total_cases,new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like 'Indi%'
order by 1,2

Select location, date, total_cases, population,(total_cases/population)*100 as percentPopulation
From PortfolioProject..CovidDeaths
Where location like 'Indi%'
order by 1,2 

Select location, MAX(total_cases) as HighestInfectionCount, population,MAX((total_cases/population))*100 as percentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like 'Indi%'
Group By location, population
order by percentPopulationInfected desc

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like 'Indi%'
where continent is not null
Group By location
order by TotalDeathCount desc

 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
 From PortfolioProject..CovidDeaths
 where Continent is not null
 order by 1,2


 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeolpleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
   order by 2,3

  

--Use CTE

With Popvsvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeolpleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
--order by 2,3
   )
   Select *, (RollingPeopleVaccinated/population)*100
   From Popvsvac
   

--Temp table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeolpleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
--order by 2,3
   
   Select *, (RollingPeopleVaccinated/population)*100
   From #PercentPopulationVaccinated

--Creating View to store data for later Visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeolpleVaccinated
 From PortfolioProject..CovidDeaths dea
 Join PortfolioProject..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
   where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated




