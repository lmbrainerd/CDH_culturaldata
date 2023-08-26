library(rvest)


# The landing page for the JMA search
coll_pages = list()
num_pages = 1:3
#NEED TO FIX IMAGES AND LINKS TO ONLY APPLIED ARTS

#"https://data.fitzmuseum.cam.ac.uk/search/results?query=pottery&operator=AND&sort=desc&department=Applied%20Arts"
url <- "https://data.fitzmuseum.cam.ac.uk/search/results?query=pottery&operator=AND&sort=desc&page="
coll_pages = paste0(url, num_pages)
session_page <- session(coll_pages[1])

collect_webpage = read_html(session_page)

# If you just use the html you get way too many 176 elements we need to select by CSS selector
# Use selector gadget for this also right click inspect to determine what was hidden
elements = html_elements(collect_webpage,"a")

# Run this and get some extras because of the hidden search memu
#elements = html_elements(collect_webpage, ".mb-3 .lead a")
#elements[29]
#CHECK selector gadget says 29 not 24

# Inspect page and see they are different h sections
# ".mb-3 h3.lead a" is the CSS selector
elements = html_elements(collect_webpage, ".mb-3 h3.lead a")

# Get the attribute called href
pages = html_attr(elements, "href")

# Come back to this
session_page = session_follow_link(session_page, "›")

# Pause to allow for time and run in loop
# Traditionally, you use i [j,k,etc] for varaible name but I like to know what I am using
all_pots = list()
for (webpage in coll_pages) {
  collect_webpage = read_html(session_page)
  elements = html_elements(collect_webpage, ".mb-3 h3.lead a")
  pages = html_attr(elements, "href")
  all_pots = append(all_pots,pages)
  Sys.sleep(2)
  print(session_page)
  session_page = session_jump_to(session_page, webpage)
}



teapot = read_html("https://data.fitzmuseum.cam.ac.uk/id/object/71313")
teapot = read_html("https://data.fitzmuseum.cam.ac.uk/id/object/201797")
teapot = read_html("https://data.fitzmuseum.cam.ac.uk/id/object/76487")
teapot = read_html("https://data.fitzmuseum.cam.ac.uk/id/object/76411")
teapot = read_html("https://data.fitzmuseum.cam.ac.uk/id/object/76905")

all_pots = list("https://data.fitzmuseum.cam.ac.uk/id/object/76487", "https://data.fitzmuseum.cam.ac.uk/id/object/17525", "https://data.fitzmuseum.cam.ac.uk/id/object/201797")


gallery = html_elements(teapot, ".object-info")

### Maker Information
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Maker(s)')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Maker(s)')]]"))
### Title
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Title')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Title')]]"))
### Description
html_text2(html_element(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Description')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Description')]]"))
### Categories
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Categories')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Categories')]]"))
### identification Numbers
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Identification numbers')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Identification numbers')]]"))
### Entities
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Entities')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Entities')]]"))

### Dating
html_text2(html_element(gallery,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'Dating')]]"))
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Dating')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Dating')]]"))
###  Acquisition and important dates
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Acquisition and important dates')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Acquisition and important dates')]]"))
### School or Style
html_text2(html_elements(gallery,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'School or Style')]]"))
style_text = html_element(gallery,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'School or Style')]]")
#wrong xpath
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'School or Style')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'School or Style')]]"))
### Materials used in production
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Materials used in production')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Materials used in production')]]"))


# write.csv(d, "testing.csv",fileEncoding = "UTF-8")





# Make an empty dataframe to add results to
pottery = data.frame()
for (pot in all_pots) {
  #For each pottery page in the list of pottery pages, do these things to it
  #Read the HTML website for the pottery page
  entry_page = read_html(pot)
  # Extract the information from element with the class object info
  obj_info = html_elements(entry_page, ".object-info")

  # Title
  title = html_elements(obj_info,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Title')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Title')]]")

  if (length(title)>1) {
    title = html_text2(title)
    title = paste0( title, collapse = ' ' )
    print(title)

  } else {
    if (length(title)!=0) {
      title = html_text2(title)
      title = gsub("\n", "|", title)
      print(paste0(title," Is Not Null"))
    } else {
      title = NA
      print("no title found")
    }
  }


  # Maker Information
  maker = html_elements(obj_info,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Maker(s)')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Maker(s)')]]")

  if (length(maker)>1) {
    maker = html_text2(maker)
    maker = paste0( maker, collapse = ' ' )
    print(maker)

  } else {
    if (length(title)!=0) {
      maker = html_text2(maker)
      maker = gsub("\n", "|", maker)
      print(paste0(maker," Is Not Null"))
    } else {
      maker = NA
      print("no maker found")
    }
  }

  # identification Numbers
  id_numbers = html_elements(obj_info,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Identification numbers')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Identification numbers')]]")
  if (length(id_numbers)>1) {
    id_numbers = html_text2(id_numbers)
    id_numbers = paste0( id_numbers, collapse = ' ' )
    print(id_numbers)

  } else {
    if (length(title)!=0) {
      id_numbers = html_text2(id_numbers)
      id_numbers = gsub("\n", "|", id_numbers)
      print(paste0(id_numbers," Is Not Null"))
    } else {
      id_numbers = NA
      print("no id_numbers found")
    }
  }

  # Categories
  category = html_elements(obj_info,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Categories')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Categories')]]")

  if (length(category)>1) {
    category = html_text2(category)
    category = paste0( category, collapse = ' ' )
    print(category)

  } else {
    if (length(title)!=0) {
      category = html_text2(category)
      category = gsub("\n", "|", category)
      print(paste0(category," Is Not Null"))
    } else {
      category = NA
      print("no category found")
    }
  }

  # Entities
  entities = html_elements(obj_info,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Entities')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Entities')]]")

  if (length(entities)>1) {
    entities = html_text2(entities)
    entities = paste0( entities, collapse = ' ' )
    print(entities)

  } else {
    if (length(title)!=0) {
      entities = html_text2(entities)
      entities = gsub("\n", "|", entities)
      print(paste0(entities," Is Not Null"))
    } else {
      entities = NA
      print("no entities found")
    }
  }

  #  Acquisition and important dates
  acqu_dates = html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Acquisition and important dates')
  ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Acquisition and important dates')]]")

  if (length(acqu_dates)>1) {
    acqu_dates = html_text2(acqu_dates)
    acqu_dates = paste0( acqu_dates, collapse = ' ' )
    print(acqu_dates)

  } else {
    if (length(acqu)!=0) {
      acqu_dates = html_text2(acqu_dates)
      acqu_dates = gsub("\n", "|", acqu_dates)
      print(paste0(acqu_dates," Is Not Null"))
    } else {
      acqu_dates = NA
      print("no acqu_dates found")
    }
  }

  # Description
  description = html_elements(obj_info,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Description')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Description')]]")

  if (length(description)>1) {
    description = html_text2(description)
    description = paste0( description, collapse = ' ' )
    print(description)

  } else {
    if (length(title)!=0) {
      description = html_text2(description)
      description = gsub("\n", "|", description)
      print(description)
    } else {
      description = NA
      print("no Description found")
    }
  }
  # Dating
  dating = html_element(obj_info,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'Dating')]]")

  if (length(dating)>1) {
    dating = html_text2(dating)
    dating = paste0( dating, collapse = ' ' )
    print(dating)

  } else {
    if (length(title)!=0) {
      dating = html_text2(dating)
      dating = gsub("\n", "|", dating)
      print(dating)
    } else {
      dating = NA
      print("no dating found")
    }
  }
  # School or Style
  school = html_element(obj_info,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'School or Style')]]")

  if (length(school)>1) {
    school = html_text2(school)
    school = paste0( school, collapse = ' ' )
    print(school)

  } else {
    if (length(title)!=0) {
      school = html_text2(school)
      school = gsub("\n", "|", school)
      print(school)
    } else {
      school = NA
      print("no school found")
    }
  }

  # Materials used in production
  materials = html_elements(obj_info,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Materials used in production')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Materials used in production')]]")

  if (length(materials)>1) {
    materials = html_text2(materials)
    materials = paste0( materials, collapse = ' ' )
    print(materials)

  } else {
    if (length(title)!=0) {
      materials = html_text2(materials)
      materials = gsub("\n", "|", materials)
      print(materials)
    } else {
      materials = NA
      print("no materials found")
    }
  }
  new_row = c(title, maker, id_numbers, category, entities, acqu_dates, description, dating, school, materials, pot)
  pottery = rbind(pottery, new_row)
  Sys.sleep(2)


}
names(pottery)<- c("Title","Maker", "Identification_Numbers", "Categories",
                   "Entities", "Acquisition_and_Important_Dates", "Description",
                   "Dating", "School_or_Style", "Materials_Used_in_Production",
                   "Website")

Uninstall.packages('rvest')
