//
//  TSNTeamTableViewCell.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A UITableView subclass to display a team item. 

#import "TSNTeamTableViewCell.h"
#import "TeamInfo.h"

@implementation TSNTeamTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTeam:(TeamInfo *)team
{
    _team = team;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@", _team.location, _team.name]; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
