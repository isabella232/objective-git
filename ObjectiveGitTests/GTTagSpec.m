//
//  GTOIDSpec.m
//  ObjectiveGitFramework
//
//  Created by Ezekiel Pierson on 2013-09-06.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

@import ObjectiveGit;
@import Nimble;
@import Quick;

#import "QuickSpec+GTFixtures.h"

QuickSpecBegin(GTTagSpec)

__block GTTag *tag;

beforeEach(^{
	NSError *error = nil;
	GTRepository *repo = self.bareFixtureRepository;
	NSString *tagSHA = @"0c37a5391bbff43c37f0d0371823a5509eed5b1d";
	tag = (GTTag *)[repo lookUpObjectBySHA:tagSHA error:&error];
	expect(error).to(beNil());
	expect(tag).notTo(beNil());
	expect(tagSHA).to(equal(tag.SHA));
});

it(@"can read tag data", ^{
	expect(tag.type).to(equal(@"tag"));
	expect(tag.name).to(equal(@"v1.0"));
	expect(tag.message).to(equal(@"test tag message\n"));
	expect(tag.target.SHA).to(equal(@"5b5b025afb0b4c913b4c338a42934a3863bf3644"));
	expect(@(GTObjectTypeCommit)).to(equal(@(tag.targetType)));

	GTSignature *signature = tag.tagger;
	expect(signature.name).to(equal(@"Scott Chacon"));
	expect(@(signature.time.timeIntervalSince1970)).to(equal(@1288114383));
	expect(signature.email).to(equal(@"schacon@gmail.com"));
});

it(@"can delete tags", ^{
	NSError *error = nil;

	BOOL success = [tag delete:&error];
	expect(@(success)).to(beTruthy());
	expect(error).to(beNil());

	success = [tag delete:&error];
	expect(@(success)).to(beFalsy());
	expect(error).notTo(beNil());
});

afterEach(^{
	[self tearDown];
});

QuickSpecEnd
