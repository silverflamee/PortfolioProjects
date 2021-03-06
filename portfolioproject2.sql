use PortfolioProject2
go

select *from dbo.NashvilleHousing

--Sale records according to date

select SaleDateConverted,
from dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(Date,SaleDate)


--Arranging Property Address & filling Null values

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
join PortfolioProject2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
join PortfolioProject2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL


-- Breaking out Address into individual Columns (Address,city,state)

--Property Address


select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as City
from PortfolioProject2.dbo.NashvilleHousing


alter table PortfolioProject2.dbo.NashvilleHousing
add PropertyAddressSplit nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
set PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)



alter table NashvilleHousing
add PropertyAddressSplitCity nvarchar(255);

update NashvilleHousing
set PropertyAddressSplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))


select*
from NashvilleHousing



--Owner Address

select

PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from NashvilleHousing


alter table PortfolioProject2.dbo.NashvilleHousing
add OwnerAddressSplit nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
set OwnerAddressSplit = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)



alter table PortfolioProject2.dbo.NashvilleHousing
add OwnerAddressCity nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
set OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)


alter table PortfolioProject2.dbo.NashvilleHousing
add OwnerAddressState nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
set OwnerAddressState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


select*
from NashvilleHousing


--Cleaning Sold as Vacant Column

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant,
case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
end
from NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
end



--Removing Duplicates

WITH RownumCTE AS ( 

select*,
Row_number() over(
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by UniqueID )row_num
from NashvilleHousing
)

select * 
from RownumCTE
where row_num > 1
order by PropertyAddress

---Deleting Duplicates


WITH RownumCTE AS ( 

select*,
Row_number() over(
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by UniqueID )row_num
from NashvilleHousing
)

DELETE 
from RownumCTE
where row_num > 1




--Removing Redundant Columns

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP Column PropertyAddress, OwnerAddress, TaxDistrict


ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP Column SaleDate

select * 
from NashvilleHousing

