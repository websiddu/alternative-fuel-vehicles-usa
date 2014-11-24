# Year of Year  Total # Alt Fuel Vehicles
us_total_afv = [
  {
    x: 1994
    y: 4486
  }
  {
    x: 1995
    y: 22227
  }
  {
    x: 1996
    y: 353995
  }
  {
    x: 1997
    y: 380352
  }
  {
    x: 1998
    y: 383847
  }
  {
    x: 1999
    y: 407542
  }
  {
    x: 2000
    y: 455838
  }
  {
    x: 2001
    y: 425458
  }
  {
    x: 2002
    y: 471098
  }
  {
    x: 2003
    y: 531708
  }
  {
    x: 2004
    y: 564986
  }
  {
    x: 2005
    y: 589767
  }
  {
    x: 2006
    y: 634205
  }
  {
    x: 2007
    y: 695318
  }
  {
    x: 2008
    y: 775103
  }
  {
    x: 2009
    y: 823322
  }
  {
    x: 2010
    y: 938643
  }
  {
    x: 2011
    y: 1191786
  }
  # {
  #   x: 2012
  #   y: 1191786
  # }
]

window.years = [1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011]
window.us_total_afv_line_y = [4486, 22227, 353995, 380352, 383847, 407542, 455838, 425458, 471098, 531708, 564986, 589767, 634205, 695318, 775103, 823322, 938643, 1191786]


us_toatl_veh = [
  {
    x: 1994
    y: 201763492
  }
  {
    x: 1995
    y: 205297050
  }
  {
    x: 1996
    y: 210236393
  }
  {
    x: 1997
    y: 211580033
  }
  {
    x: 1998
    y: 215496003
  }
  {
    x: 1999
    y: 220461056
  }
  {
    x: 2000
    y: 225821241
  }
  {
    x: 2001
    y: 235331382
  }
  {
    x: 2002
    y: 234624135
  }
  {
    x: 2003
    y: 236760033
  }
  {
    x: 2004
    y: 243023486
  }
  {
    x: 2005
    y: 247421120
  }
  {
    x: 2006
    y: 250844644
  }
  {
    x: 2007
    y: 254403081
  }
  {
    x: 2008
    y: 255917663
  }
  {
    x: 2009
    y: 254212610
  }
  {
    x: 2010
    y: 250070048
  }
  {
    x: 2011
    y: 253215681
  }
  {
    x: 2012
    y: 253639386
  }
]


total_carbon_emissions = [
  # { x: 1990, y: 31.08}
  # { x: 1991, y: 30.65}
  # { x: 1992, y: 31.10}
  # { x: 1993, y: 31.62}
  { x: 1994, y: 32.33}
  { x: 1995, y: 32.99}
  { x: 1996, y: 33.95}
  { x: 1997, y: 34.34}
  { x: 1998, y: 35.08}
  { x: 1999, y: 36.00}
  { x: 2000, y: 36.85}
  { x: 2001, y: 36.45}
  { x: 2002, y: 37.25}
  { x: 2003, y: 37.26}
  { x: 2004, y: 38.60}
  { x: 2005, y: 39.15}
  { x: 2006, y: 39.76}
  { x: 2007, y: 40.10}
  { x: 2008, y: 37.83}
  { x: 2009, y: 36.61}
  { x: 2010, y: 37.07}
  { x: 2011, y: 36.53}
  # { x: 2012, y: 35.87}
]


window.us_total_afv_line = [
  {
    values: us_total_afv
    key: 'AF Vehicles'
  }
  # {
  #   values: us_toatl_veh
  #   key: 'All Vehicles'
  # }
]

window.us_total_carbon = [
  {
    values: total_carbon_emissions
    key: "Carbon emission (MMTCO2)"
    color: "green"
  }
]

window.v_type = ["Vans (Minivans)", "Vans (Medium Duty)", "Vans (Light Duty)", "Trucks", "Pickups", "Other Vehicles", "Motorcycles", "Low Speed Vehicles", "Buses", "Automobiles (Subcompact)", "Automobiles (Midsize)", "Automobiles (Fullsize)", "Automobiles (Compact)"]

window.us_total_aft_split = [{"values":[{"x":2010,"y":5339},{"x":2009,"y":5747},{"x":2008,"y":3812},{"x":2007,"y":2287},{"x":2006,"y":1980},{"x":2005,"y":1899},{"x":2004,"y":2101},{"x":2003,"y":1736},{"x":2002,"y":3094},{"x":2001,"y":3201},{"x":2000,"y":2744},{"x":1999,"y":3389},{"x":1998,"y":3471},{"x":1997,"y":4285},{"x":1996,"y":5027},{"x":1995,"y":4065},{"x":1994,"y":3335}].reverse(),"key":"Heavy Duty"},{"values":[{"x":2010,"y":1665858},{"x":2009,"y":1057237},{"x":2008,"y":1492387},{"x":2007,"y":1269073},{"x":2006,"y":1115542},{"x":2005,"y":879910},{"x":2004,"y":768545},{"x":2003,"y":924435},{"x":2002,"y":888351},{"x":2001,"y":613061},{"x":2000,"y":615657},{"x":1999,"y":436805},{"x":1998,"y":226360},{"x":1997,"y":87830},{"x":1996,"y":14153},{"x":1995,"y":11412},{"x":1994,"y":8929}].reverse(),"key":"Light Duty"},{"values":[{"x":2010,"y":93510},{"x":2009,"y":13366},{"x":2008,"y":13334},{"x":2007,"y":183323},{"x":2006,"y":117133},{"x":2005,"y":8472},{"x":2004,"y":4992},{"x":2003,"y":4367},{"x":2002,"y":4539},{"x":2001,"y":6781},{"x":2000,"y":14949},{"x":1999,"y":2515},{"x":1998,"y":3130},{"x":1997,"y":2253},{"x":1996,"y":2440},{"x":1995,"y":2519},{"x":1994,"y":2310}].reverse(),"key":"Medium Duty"}]

window.veh_types = {"Vans (Minivans)":[45487,44849,44319,50620,79399,87525,105200,153767],"Vans (Medium Duty)":[19315,18803,18032,17080,17387,18654,26342,42460],"Vans (Light Duty)":[55230,52928,50556,49042,47185,45799,44576,43950],"Trucks":[68707,66785,64890,63710,63631,63358,65075,64745],"SUVs":[55427,63414,77231,89394,97739,106153,126475,173583],"Pickups":[160403,168270,181069,195102,204066,214003,235767,276142],"Other Vehicles":[0,0,1,1,1,1,1,0],"Motorcycles":[1238,1225,1309,1664,1993,2182,2363,2504],"Low Speed Vehicles":[37184,39226,41505,43682,44934,45412,45864,45452],"Buses":[21006,22008,22851,23578,24768,26632,28525,30070],"Automobiles (Subcompact)":[6161,6167,6140,6019,5838,5598,5368,5106],"Automobiles (Midsize)":[47387,48277,48914,53863,69858,85928,119793,207875],"Automobiles (Fullsize)":[13566,19184,31319,44862,59837,64208,72107,81264],"Automobiles (Compact)":[34381,40989,46426,57149,59031,60865,61187,61007]}

window.fuel_type =   {"Liquefied Petroleum Gas":[182864,173795,164846,158254,151049,147030,143037,136970],"Liquefied Natural Gas":[2717,2748,2798,2781,3101,3176,3354,3086],"Ethanol, 85 percent":[211800,246363,297099,364384,450327,504297,618506,862679],"Electricity":[49536,51398,53526,55730,56901,57185,57462,66614],"Compressed Natural Gas":[118532,117699,116131,114391,113973,114270,115863,118168],"Other Fuels":[0,3,3,3,3,3,0,0],"Hydrogen":[43,119,159,223,313,357,421,408]}

window.fuel_consumption = {"Liquefied Petroleum Gas":[211883,188171,173130,152360,147784,129631,126354,122949],"Liquefied Natural Gas":[20888,22409,23474,24594,25554,25652,26072,25434],"Ethanol, 85 percent":[31581,38074,44041,54091,62464,71213,90323,137041],"Electricity":[5269,5219,5104,5037,5050,4956,4847,7464],"Compressed Natural Gas":[158903,166878,172011,178565,189358,199513,210007,220155],"Other Fuels":[0,2,2,2,2,2,0,0],"Hydrogen":[8,25,41,66,117,140,152,76]}
