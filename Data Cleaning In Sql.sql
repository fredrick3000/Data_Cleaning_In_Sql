--Data Cleaning in SQL Queries
--i. Standardise Date Format
Select SaleDateConverted, CONVERT(Date, SaleDate)
From Portfolio_Project1..Housing

UPDATE Portfolio_Project1..Housing
Set SaleDateConverted = CONVERT(Date, SaleDate)

Alter Table Portfolio_Project1..Housing
add SaleDateConverted Date;

UPDATE Portfolio_Project1..Housing
set SaleDateConverted = CONVERT(Date, SaleDate)

--ii. Populate Property Address Data

Select Alpha.ParcelID, Alpha.PropertyAddress, Omega.ParcelID, Omega.PropertyAddress, isnull(Alpha.PropertyAddress,Omega.PropertyAddress)
From Portfolio_Project1..Housing Alpha
join Portfolio_Project1..Housing Omega
on Alpha.ParcelID = Omega.ParcelID
and Alpha.[UniqueID ] <> Omega.[UniqueID ]
where Alpha.PropertyAddress is null

UPDATE Alpha
Set PropertyAddress = isnull(Alpha.PropertyAddress,Omega.PropertyAddress)
From Portfolio_Project1..Housing Alpha
join Portfolio_Project1..Housing Omega
on Alpha.ParcelID = Omega.ParcelID
and Alpha.[UniqueID ] <> Omega.[UniqueID ]
where Alpha.PropertyAddress is null


--iii. Breaking out address into individual columns such as; Address and City   

Select 
PARSENAME(Replace(PropertyAddress, ',','.'), 1),
PARSENAME(Replace(PropertyAddress, ',','.'), 2)
From Portfolio_Project1..Housing

Alter Table Portfolio_Project1..Housing
add PropertySplitcity Nvarchar(255);

UPDATE Portfolio_Project1..Housing
Set PropertySplitcity = PARSENAME(Replace(PropertyAddress, ',','.'), 1)


Alter Table Portfolio_Project1..Housing
add PropertySplitAddress Nvarchar(255);

UPDATE Portfolio_Project1..Housing
Set PropertySplitAddress = PARSENAME(Replace(PropertyAddress, ',','.'), 2)

--iv. Breaking out Owner address into individual columns such as; Address, City and State  

Select 
PARSENAME(Replace(OwnerAddress,',','.'), 1),
PARSENAME(Replace(OwnerAddress,',','.'), 2),
PARSENAME(Replace(OwnerAddress,',','.'),3)
C
Alter Table Portfolio_Project1..Housing
add OwnerState Nvarchar(255)

UPDATE Portfolio_Project1..Housing
Set OwnerState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

Alter Table Portfolio_Project1..Housing
add OwnerCity Nvarchar(255)

UPDATE Portfolio_Project1..Housing
Set OwnerCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)


Alter Table Portfolio_Project1..Housing
add OwnerSplitAddress Nvarchar(255)

UPDATE Portfolio_Project1..Housing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)


--v. Change 'Y' and 'N' to 'Yes' and 'No' in 'Sold as vacant' column

Select Distinct (SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio_Project1..Housing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
From Portfolio_Project1..Housing

UPDATE Portfolio_Project1..Housing
Set  SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End

--vi. Deleting Unusable Columns

Select *
From Portfolio_Project1..Housing


ALTER TABLE Portfolio_Project1..Housing
Drop COLUMN SaleDate

ALTER TABLE Portfolio_Project1..Housing
Drop COLUMN PropertyAddress, OwnerAddress


