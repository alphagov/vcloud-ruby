module VCloud
  class Catalog < BaseVCloudEntity
    include ParsesXml

    has_type VCloud::Constants::ContentType::CATALOG
    has_links
    has_reference :catalog_item_references, VCloud::Constants::Xpath::CATALOG_ITEM_REFERENCE
    has_default_attributes

    def get_catalog_item_refs_by_name
      refs_by_name = {}
      @catalog_item_references.each do |item|
        refs_by_name[item.name] = item
      end
      return refs_by_name
    end
    
    def get_catalog_item_from_name(name)
      catalog_items = get_catalog_item_refs_by_name
      item = catalog_items[name]
      CatalogItem.from_reference(item)
    end
  end
end