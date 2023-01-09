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
teapot = read_html("https://data.fitzmuseum.cam.ac.uk/id/object/76487")

gallery = html_elements(teapot, ".object-info")

# Maker Information
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Maker(s)')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Maker(s)')]]"))
# Title
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Title')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Title')]]"))
# Description
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Description')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Description')]]"))
# Categories
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Categories')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Categories')]]"))
# identification Numbers
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Identification numbers')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Identification numbers')]]"))
# Entities
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Entities')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Entities')]]"))
# Dating
html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Dating')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Dating')]]")

html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Dating')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Dating')]]"))
html_text2(html_element(gallery,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'Dating')]]"))
#  Acquisition and important dates
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Acquisition and important dates')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Acquisition and important dates')]]"))
# School or Style
html_text2(html_element(gallery,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'School or Style')]]"))
style_text = html_text2(html_element(gallery,xpath = "//*/descendant::p[preceding-sibling::h3[contains(text(), 'School or Style')]]"))
# Materials used in production
html_text2(html_elements(gallery,xpath = "//h3[preceding-sibling::h3[contains(text(), 'Materials used in production')
                         ]][1]/preceding-sibling::*[preceding-sibling::h3[contains(text(), 'Materials used in production')]]"))

#Need to clean the results and then put in a for loop to be added to a dataframe
# Each Entry with multiple with have to be separated into a list Store using pipe |
# write.csv(d, "testing.csv",fileEncoding = "UTF-8")





