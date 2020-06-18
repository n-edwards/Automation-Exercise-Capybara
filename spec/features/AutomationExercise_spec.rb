require 'spec_helper'

# Quick example of how to use Page Objects. Not fully implemented across tests.
class MainPage < SitePrism::Page
  set_url '/'
  element :product_search_field, "input[placeholder='What are you looking for?']"

  def search_product(prod)
    product_search_field.set(prod)
    product_search_field.send_keys :enter
  end
end

describe "Williams Sonoma automation exercise", type: :feature do

  let(:main_page) { MainPage.new } # SitePrism

  before :each do
    # visit '/'
    main_page.load
    # Wait for email signup modal to appear, and refresh it away.
    # TODO: get better HTML hooks added to modal so it can be closed easily in an if statement, or find a way to initiate session with no modal.
    sleep 4
    main_page.refresh
    sleep 2
  end
  
  it "Checks adding to cart" do

    find('.topnav-cooks-tools').hover
    sleep 2 # Use some sleeps for elements that fade in or are slow to load. TODO: add clearer waits or more finders.
    find('a[href="https://www.williams-sonoma.com/shop/cooks-tools/salt-pepper-mills/?cm_type=gnav"]').click
    find('li[data-product="{productSku:\'9523796\',groupId:\'graviti-electric-salt-and-pepper-mills\'}"]').click
    # expect(page).to have_css('button[aria-label="Add to Cart"]') # Optional
    sleep 3
    click_link('Salt Mill') # Type selection required
    first('input[aria-label="Quantity"]').click # Focus
    first('input[aria-label="Quantity"]').fill_in with: '11' # Quantity required
    sleep 2
    first('button[aria-label="Add to Cart"]').click # Only works when type and quantity are done
    sleep 2
    # binding.pry
    expect(page).to have_css('div[class="overlayWidget modal confirmationOverlay"]')
    find('a[href="https://www.williams-sonoma.com/checkout/normal.html"]').click # In overlay.
    expect(page).to have_css('.cart-table-row-title') # Check for some elements we expect to be on checkout page
    expect(page).to have_css('a[href="https://www.williams-sonoma.com/products/graviti-electric-salt-and-pepper-mills/?cm_src=E%3Asalt-pepper-mills"]') # Check for slected product
      
    
  end

  it "Check search and quick look" do
      
    # fill_in 'What are you looking for?', with: 'Trudeau Graviti Electric Salt & Pepper Mills'
    # find('input[placeholder="What are you looking for?"]').send_keys :enter
    main_page.search_product('Trudeau Graviti Electric Salt & Pepper Mills') #POM example
    find('a[data-overlay-href^="https://www.williams-sonoma.com/products/trudeau-graviti-copper-electric-salt-pepper-mills/quicklook.html"]').click
    within ('.overlayWidget') do
      expect(page).to have_text 'Trudeau Graviti Electric Salt & Pepper Mills, Copper'
    end
    
    # binding.pry
  end  
end
